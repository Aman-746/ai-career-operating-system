package com.aman.careeros.service;

import com.aman.careeros.config.AssessmentRoleConfig;
import com.aman.careeros.config.AssessmentRoleConfig.TopicConfig;
import com.aman.careeros.dto.AssessmentConfigDto;
import com.aman.careeros.dto.AssessmentIntroResponse;
import com.aman.careeros.dto.AssessmentResultResponse;
import com.aman.careeros.dto.GapAnalysis;
import com.aman.careeros.dto.QuestionDto;
import com.aman.careeros.dto.QuestionResultDto;
import com.aman.careeros.dto.StartAssessmentResponse;
import com.aman.careeros.dto.SubmitAnswersRequest;
import com.aman.careeros.dto.SubmitAssessmentResponse;
import com.aman.careeros.entity.GapAnalysisStatus;
import com.aman.careeros.entity.AssessmentResponse;
import com.aman.careeros.entity.AssessmentSession;
import com.aman.careeros.entity.AssessmentTopic;
import com.aman.careeros.entity.ExperienceLevel;
import com.aman.careeros.entity.OnboardingProfile;
import com.aman.careeros.entity.Question;
import com.aman.careeros.entity.Resume;
import com.aman.careeros.entity.User;
import com.aman.careeros.exception.InvalidRequestException;
import com.aman.careeros.exception.ResourceNotFoundException;
import com.aman.careeros.repository.AssessmentResponseRepository;
import com.aman.careeros.repository.AssessmentSessionRepository;
import com.aman.careeros.repository.OnboardingProfileRepository;
import com.aman.careeros.repository.QuestionRepository;
import com.aman.careeros.repository.ResumeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * AssessmentService - Handles assessment intro and session lifecycle.
 *
 * assessmentStatus is "AVAILABLE" when the role has a curated config,
 * "COMING_SOON" otherwise. assessmentConfig is null for coming-soon roles.
 *
 * Question selection: 2 EASY + 2 MEDIUM + 2 HARD per topic (6 per topic).
 * Questions are ordered by topic then difficulty in the frozen plan so the
 * frontend can paginate 6 at a time without needing server-side paging.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class AssessmentService {

        private static final int QUESTIONS_PER_DIFFICULTY = 2;

        private final OnboardingProfileRepository profileRepository;
        private final ResumeRepository resumeRepository;
        private final AssessmentRoleConfig roleConfig;
        private final QuestionRepository questionRepository;
        private final AssessmentSessionRepository sessionRepository;
        private final AssessmentResponseRepository responseRepository;
        private final GapAnalysisService gapAnalysisService;

        public AssessmentIntroResponse getIntro(User user) {
                OnboardingProfile profile = profileRepository.findByUserId(user.getId())
                                .orElseThrow(() -> new ResourceNotFoundException("Onboarding profile not found"));

                Resume resume = resumeRepository.findTopByUserIdOrderByUploadedAtDesc(user.getId())
                                .orElseThrow(() -> new ResourceNotFoundException("Resume not found"));

                Optional<TopicConfig> topicConfigOpt = roleConfig.getConfig(profile.getTargetRole());
                ExperienceLevel difficulty = ExperienceLevel.fromYearsOfExperience(profile.getYearsOfExperience());

                String assessmentStatus = topicConfigOpt.isPresent() ? "AVAILABLE" : "COMING_SOON";
                AssessmentConfigDto assessmentConfig = topicConfigOpt.map(tc -> AssessmentConfigDto.builder()
                                .topics(tc.topics())
                                .questionCount(tc.questionCount())
                                .estimatedMinutes(tc.estimatedMinutes())
                                .difficultyLevel(difficulty)
                                .build()).orElse(null);

                UUID completedSessionId = sessionRepository
                                .findTopByUserIdAndStatusOrderByCreatedAtDesc(
                                                user.getId(), AssessmentSession.Status.COMPLETED)
                                .map(AssessmentSession::getId)
                                .orElse(null);

                return AssessmentIntroResponse.builder()
                                .userName(user.getName())
                                .currentRole(profile.getCurrentRole())
                                .targetRole(profile.getTargetRole())
                                .targetCompany(profile.getTargetCompany())
                                .yearsOfExperience(profile.getYearsOfExperience())
                                .fileName(resume.getOriginalFilename())
                                .detectedSkills(resume.getDetectedSkills())
                                .experienceLevel(resume.getExperienceLevel())
                                .assessmentStatus(assessmentStatus)
                                .assessmentConfig(assessmentConfig)
                                .completedSessionId(completedSessionId)
                                .build();
        }

        /**
         * POST /api/assessment/start
         *
         * Creates a new IN_PROGRESS session with a frozen question plan, or resumes
         * the user's existing open session if one is already in progress.
         *
         * Selection: 2 EASY + 2 MEDIUM + 2 HARD per topic, randomised by the DB
         * (ORDER BY random() in QuestionRepository). Questions are grouped by topic
         * so the frontend can page through 6 questions at a time without sorting.
         */
        @Transactional
        public StartAssessmentResponse startAssessment(User user) {
                OnboardingProfile profile = profileRepository.findByUserId(user.getId())
                                .orElseThrow(() -> new ResourceNotFoundException("Onboarding profile not found"));

                TopicConfig topicConfig = roleConfig.getConfig(profile.getTargetRole())
                                .orElseThrow(() -> new InvalidRequestException(
                                                "Assessment not yet available for role: " + profile.getTargetRole()));

                // Resume an existing open session rather than creating a duplicate
                Optional<AssessmentSession> existing = sessionRepository.findByUserIdAndStatus(
                                user.getId(), AssessmentSession.Status.IN_PROGRESS);
                if (existing.isPresent()) {
                        return buildStartResponse(existing.get());
                }

                List<UUID> questionIds = new ArrayList<>();
                for (AssessmentTopic topic : topicConfig.topics()) {
                        questionIds.addAll(pickQuestions(topic, Question.Difficulty.EASY));
                        questionIds.addAll(pickQuestions(topic, Question.Difficulty.MEDIUM));
                        questionIds.addAll(pickQuestions(topic, Question.Difficulty.HARD));
                }

                AssessmentSession session = AssessmentSession.builder()
                                .user(user)
                                .targetRole(profile.getTargetRole())
                                .status(AssessmentSession.Status.IN_PROGRESS)
                                .questionIds(questionIds)
                                .build();
                sessionRepository.save(session);

                return buildStartResponse(session);
        }

        private List<UUID> pickQuestions(AssessmentTopic topic, Question.Difficulty difficulty) {
                List<Question> questions = questionRepository.findActiveByTopicAndDifficulty(topic, difficulty);

                Collections.shuffle(questions);

                return questions.stream()
                                .limit(QUESTIONS_PER_DIFFICULTY)
                                .map(Question::getId)
                                .toList();

                // return questionRepository.findActiveByTopicAndDifficulty(topic, difficulty)
                //                 .stream()
                // .limit(QUESTIONS_PER_DIFFICULTY)
                // .map(Question::getId)
                // .toList();
        } 

        private StartAssessmentResponse buildStartResponse(AssessmentSession session) {
                Map<UUID, Question> byId = questionRepository.findAllById(session.getQuestionIds())
                                .stream()
                                .collect(Collectors.toMap(Question::getId, q -> q));

                List<QuestionDto> questions = session.getQuestionIds().stream()
                                .map(id -> QuestionDto.from(byId.get(id)))
                                .toList();

                int estimatedMinutes = roleConfig.getConfig(session.getTargetRole())
                                .map(TopicConfig::estimatedMinutes)
                                .orElse(0);

                return StartAssessmentResponse.builder()
                                .sessionId(session.getId())
                                .targetRole(session.getTargetRole())
                                .totalQuestions(questions.size())
                                .estimatedMinutes(estimatedMinutes)
                                .questions(questions)
                                .build();
        }

        /**
         * POST /api/assessment/submit
         *
         * Validates that every question in the frozen session plan has an answer,
         * persists each response with its correctness flag, computes per-topic
         * scores, and marks the session COMPLETED.
         *
         * Score bands (out of 6 questions per topic):
         * STRONG ≥ 80% (5-6 correct)
         * PROFICIENT ≥ 60% (4 correct)
         * DEVELOPING ≥ 40% (3 correct)
         * WEAK < 40% (0-2 correct)
         */
        @Transactional
        public SubmitAssessmentResponse submitAssessment(User user, SubmitAnswersRequest request) {
                AssessmentSession session = sessionRepository
                                .findByIdAndUserId(request.getSessionId(), user.getId())
                                .orElseThrow(() -> new ResourceNotFoundException("Assessment session not found"));

                if (session.getStatus() == AssessmentSession.Status.COMPLETED) {
                        throw new InvalidRequestException("Assessment session is already completed");
                }

                Set<UUID> sessionQuestionIds = new HashSet<>(session.getQuestionIds());
                Set<UUID> submittedIds = request.getAnswers().stream()
                                .map(SubmitAnswersRequest.AnswerDto::getQuestionId)
                                .collect(Collectors.toSet());
                if (!sessionQuestionIds.equals(submittedIds)) {
                        throw new InvalidRequestException(
                                        "Submitted answers must cover every question in the session exactly once");
                }

                Map<UUID, Question> questionById = questionRepository.findAllById(session.getQuestionIds())
                                .stream()
                                .collect(Collectors.toMap(Question::getId, q -> q));

                List<AssessmentResponse> responses = request.getAnswers().stream()
                                .map(answer -> {
                                        Question q = questionById.get(answer.getQuestionId());
                                        boolean correct = q.getCorrectOptionId().equals(answer.getSelectedOptionId());
                                        return AssessmentResponse.builder()
                                                        .session(session)
                                                        .question(q)
                                                        .topic(q.getTopic())
                                                        .selectedOptionId(answer.getSelectedOptionId())
                                                        .correct(correct)
                                                        .build();
                                })
                                .toList();
                responseRepository.saveAll(responses);

                session.setTopicScores(computeTopicScores(responses));
                session.setStatus(AssessmentSession.Status.COMPLETED);
                session.setCompletedAt(LocalDateTime.now());
                sessionRepository.save(session);

                return new SubmitAssessmentResponse(session.getId(), session.getStatus().name());
        }

        private List<AssessmentSession.TopicScore> computeTopicScores(List<AssessmentResponse> responses) {
                return responses.stream()
                                .collect(Collectors.groupingBy(AssessmentResponse::getTopic))
                                .entrySet().stream()
                                .map(e -> {
                                        AssessmentTopic topic = e.getKey();
                                        List<AssessmentResponse> topicResponses = e.getValue();
                                        int asked = topicResponses.size();
                                        int correct = (int) topicResponses.stream()
                                                        .filter(AssessmentResponse::isCorrect).count();
                                        int score = asked == 0 ? 0 : (correct * 100) / asked;
                                        return new AssessmentSession.TopicScore(
                                                        topic.name(),
                                                        topic.getDisplayName(),
                                                        asked,
                                                        correct,
                                                        score,
                                                        scoreBand(score));
                                })
                                .sorted(Comparator.comparing(AssessmentSession.TopicScore::topic))
                                .toList();
        }

        private String scoreBand(int score) {
                if (score >= 80)
                        return "STRONG";
                if (score >= 60)
                        return "PROFICIENT";
                if (score >= 40)
                        return "DEVELOPING";
                return "WEAK";
        }


        @Transactional
        public AssessmentResultResponse getResult(User user, UUID sessionId) {

                AssessmentSession session = sessionRepository.findByIdAndUserId(sessionId, user.getId())
                                .orElseThrow(() -> new ResourceNotFoundException("Assessment session not found"));

                if (session.getStatus() != AssessmentSession.Status.COMPLETED) {
                        throw new InvalidRequestException("Assessment session is not yet completed");
                }

                List<AssessmentResponse> responses = responseRepository.findBySessionId(sessionId);

                Set<UUID> questionIds = responses.stream()
                                .map(r -> r.getQuestion().getId())
                                .collect(Collectors.toSet());
                Map<UUID, Question> questionById = questionRepository.findAllById(questionIds)
                                .stream()
                                .collect(Collectors.toMap(Question::getId, q -> q));

                // Preserve the original question order from the frozen session plan
                Map<UUID, Integer> positionByQuestionId = new HashMap<>();
                List<UUID> orderedIds = session.getQuestionIds();
                for (int i = 0; i < orderedIds.size(); i++) {
                        positionByQuestionId.put(orderedIds.get(i), i);
                }

                List<QuestionResultDto> questionResults = responses.stream()
                                .map(r -> {
                                        Question q = questionById.get(r.getQuestion().getId());
                                        return new QuestionResultDto(
                                                        q.getId(),
                                                        q.getTopic(),
                                                        q.getDifficulty(),
                                                        q.getStem(),
                                                        q.getOptions(),
                                                        r.getSelectedOptionId(),
                                                        q.getCorrectOptionId(),
                                                        r.isCorrect(),
                                                        q.getExplanation());
                                })
                                .sorted(Comparator.comparingInt(dto -> positionByQuestionId
                                                .getOrDefault(dto.questionId(), Integer.MAX_VALUE)))
                                .toList();

                int totalCorrect = (int) responses.stream().filter(AssessmentResponse::isCorrect).count();
                int totalQuestions = responses.size();
                int overallScore = totalQuestions == 0 ? 0 : (totalCorrect * 100) / totalQuestions;

                // Lazy-generate on first fetch; serve from cache on repeat calls.
                GapAnalysisStatus currentStatus = session.getGapAnalysisStatus();
                if (currentStatus == null || currentStatus == GapAnalysisStatus.NONE) {
                        try {
                                GapAnalysis analysis = gapAnalysisService.generate(
                                                session, user, responses, questionById);
                                if (analysis != null) {
                                        session.setGapAnalysis(analysis);
                                        session.setGapAnalysisStatus(GapAnalysisStatus.READY);
                                        sessionRepository.save(session);
                                }
                        } catch (Exception e) {
                                log.warn("Gap analysis failed for session {}: {}", sessionId, e.getMessage());
                                session.setGapAnalysisStatus(GapAnalysisStatus.FAILED);
                                sessionRepository.save(session);
                        }
                }

                return AssessmentResultResponse.builder()
                                .sessionId(session.getId())
                                .targetRole(session.getTargetRole())
                                .completedAt(session.getCompletedAt())
                                .totalQuestions(totalQuestions)
                                .totalCorrect(totalCorrect)
                                .overallScore(overallScore)
                                .topicScores(session.getTopicScores())
                                .questionResults(questionResults)
                                .gapAnalysisStatus(session.getGapAnalysisStatus())
                                .gapAnalysis(session.getGapAnalysis())
                                .build();
        }
}
