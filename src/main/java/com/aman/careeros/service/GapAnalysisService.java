package com.aman.careeros.service;

import com.aman.careeros.ai.GapAnalysisClient;
import com.aman.careeros.config.AiServiceProperties;
import com.aman.careeros.config.AssessmentRoleConfig;
import com.aman.careeros.dto.GapAnalysis;
import com.aman.careeros.dto.GapAnalysisRequest;
import com.aman.careeros.entity.AssessmentResponse;
import com.aman.careeros.entity.AssessmentSession;
import com.aman.careeros.entity.AssessmentTopic;
import com.aman.careeros.entity.ExperienceLevel;
import com.aman.careeros.entity.Question;
import com.aman.careeros.entity.User;
import com.aman.careeros.exception.InvalidRequestException;
import com.aman.careeros.exception.ResourceNotFoundException;
import com.aman.careeros.repository.OnboardingProfileRepository;
import com.aman.careeros.repository.ResumeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class GapAnalysisService {

    private final AiServiceProperties aiServiceProperties;
    private final OnboardingProfileRepository profileRepository;
    private final ResumeRepository resumeRepository;
    private final AssessmentRoleConfig roleConfig;
    private final GapAnalysisClient gapAnalysisClient;

    /**
     * Assembles the context bundle from the user's resume, profile, and session,
     * then delegates to the Python AI service. Returns null if the feature is
     * disabled so the caller can distinguish "not attempted" from "failed".
     */
    public GapAnalysis generate(
            AssessmentSession session,
            User user,
            List<AssessmentResponse> responses,
            Map<UUID, Question> questionById) {

        if (!aiServiceProperties.isEnabled() || aiServiceProperties.getBaseUrl().isBlank()) {
            log.debug("AI service disabled — skipping gap analysis for session {}", session.getId());
            return null;
        }

        var profile = profileRepository.findByUserId(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Onboarding profile not found"));

        var resume = resumeRepository.findTopByUserIdOrderByUploadedAtDesc(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Resume not found"));

        AssessmentRoleConfig.TopicConfig topicConfig = roleConfig.getConfig(session.getTargetRole())
                .orElseThrow(() -> new InvalidRequestException(
                        "No role config for: " + session.getTargetRole()));

        List<String> expectedTopics = topicConfig.topics().stream()
                .map(AssessmentTopic::getDisplayName)
                .toList();

        List<GapAnalysisRequest.MissedQuestion> missedQuestions = responses.stream()
                .filter(r -> !r.isCorrect())
                .map(r -> {
                    Question q = questionById.get(r.getQuestion().getId());
                    return new GapAnalysisRequest.MissedQuestion(
                            q.getTopic().name(),
                            q.getTopic().getDisplayName(),
                            q.getDifficulty().name(),
                            q.getStem());
                })
                .toList();

        ExperienceLevel expLevel = ExperienceLevel.fromYearsOfExperience(profile.getYearsOfExperience());

        GapAnalysisRequest request = new GapAnalysisRequest(
                session.getTargetRole(),
                expLevel.name(),
                profile.getYearsOfExperience(),
                resume.getDetectedSkills() != null ? resume.getDetectedSkills() : List.of(),
                expectedTopics,
                session.getTopicScores(),
                missedQuestions);

        return gapAnalysisClient.analyze(request);
    }
}
