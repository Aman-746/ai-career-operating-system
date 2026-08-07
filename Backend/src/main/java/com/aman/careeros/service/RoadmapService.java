package com.aman.careeros.service;

import com.aman.careeros.ai.RoadmapGenerationClient;
import com.aman.careeros.config.AiServiceProperties;
import com.aman.careeros.dto.GenerateRoadmapRequest;
import com.aman.careeros.dto.RoadmapAiRequest;
import com.aman.careeros.dto.RoadmapAiResponse;
import com.aman.careeros.dto.RoadmapItemDto;
import com.aman.careeros.dto.RoadmapResponse;
import com.aman.careeros.dto.UpdateItemStatusRequest;
import com.aman.careeros.dto.WeekDto;
import com.aman.careeros.entity.AssessmentSession;
import com.aman.careeros.entity.ExperienceLevel;
import com.aman.careeros.entity.Roadmap;
import com.aman.careeros.entity.RoadmapItem;
import com.aman.careeros.entity.User;
import com.aman.careeros.exception.InvalidRequestException;
import com.aman.careeros.exception.ResourceNotFoundException;
import com.aman.careeros.repository.AssessmentSessionRepository;
import com.aman.careeros.repository.OnboardingProfileRepository;
import com.aman.careeros.repository.ResumeRepository;
import com.aman.careeros.repository.RoadmapItemRepository;
import com.aman.careeros.repository.RoadmapRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class RoadmapService {

    private final AiServiceProperties aiServiceProperties;
    private final RoadmapRepository roadmapRepository;
    private final RoadmapItemRepository roadmapItemRepository;
    private final OnboardingProfileRepository profileRepository;
    private final ResumeRepository resumeRepository;
    private final AssessmentSessionRepository assessmentSessionRepository;
    private final RoadmapGenerationClient roadmapGenerationClient;

    @Transactional
    public RoadmapResponse generate(User user, GenerateRoadmapRequest request) {
        if (!aiServiceProperties.isEnabled() || aiServiceProperties.getBaseUrl().isBlank()) {
            throw new InvalidRequestException("AI service is disabled");
        }

        var profile = profileRepository.findByUserId(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Complete onboarding before generating a roadmap"));

        var resume = resumeRepository.findTopByUserIdOrderByUploadedAtDesc(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Upload your resume before generating a roadmap"));

        var session = assessmentSessionRepository
                .findTopByUserIdAndStatusOrderByCreatedAtDesc(user.getId(), AssessmentSession.Status.COMPLETED)
                .orElseThrow(() -> new ResourceNotFoundException("Complete your assessment before generating a roadmap"));

        var gapAnalysis = session.getGapAnalysis();

        var aiRequest = new RoadmapAiRequest(
                request.targetRole(),
                request.totalWeeks(),
                ExperienceLevel.fromYearsOfExperience(profile.getYearsOfExperience()).name(),
                profile.getYearsOfExperience(),
                resume.getDetectedSkills() != null ? resume.getDetectedSkills() : List.of(),
                session.getTopicScores() != null ? session.getTopicScores() : List.of(),
                gapAnalysis != null
                        ? gapAnalysis.gaps().stream()
                                .map(g -> new RoadmapAiRequest.GapSummary(g.area(), g.severity()))
                                .toList()
                        : List.of(),
                gapAnalysis != null
                        ? gapAnalysis.strengths().stream()
                                .map(s -> new RoadmapAiRequest.StrengthSummary(s.area(), s.evidence()))
                                .toList()
                        : List.of());

        RoadmapAiResponse aiResponse = roadmapGenerationClient.generate(aiRequest);

        // Archive existing active roadmap before saving the new one
        roadmapRepository.findByUserIdAndStatus(user.getId(), Roadmap.Status.ACTIVE)
                .ifPresent(existing -> {
                    existing.setStatus(Roadmap.Status.ARCHIVED);
                    roadmapRepository.save(existing);
                });

        var roadmap = roadmapRepository.save(Roadmap.builder()
                .user(user)
                .targetRole(request.targetRole())
                .totalWeeks(request.totalWeeks())
                .rationale(aiResponse.rationale())
                .modelId(aiResponse.modelMeta() != null ? aiResponse.modelMeta().modelId() : null)
                .build());

        List<RoadmapItem> items = new ArrayList<>();
        for (RoadmapAiResponse.WeekPlan week : aiResponse.weeks()) {
            List<RoadmapAiResponse.ItemPlan> weekItems = week.items();
            for (int i = 0; i < weekItems.size(); i++) {
                RoadmapAiResponse.ItemPlan plan = weekItems.get(i);
                items.add(RoadmapItem.builder()
                        .roadmap(roadmap)
                        .weekNumber(week.weekNumber())
                        .topicName(plan.topicName())
                        .category(plan.category())
                        .sortOrder(i)
                        .build());
            }
        }
        roadmapItemRepository.saveAll(items);

        return toResponse(roadmap, items);
    }

    @Transactional(readOnly = true)
    public RoadmapResponse getActive(User user) {
        var roadmap = roadmapRepository.findByUserIdAndStatus(user.getId(), Roadmap.Status.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("No active roadmap found. Generate one first."));

        List<RoadmapItem> items =
                roadmapItemRepository.findAllByRoadmapIdOrderByWeekNumberAscSortOrderAsc(roadmap.getId());

        return toResponse(roadmap, items);
    }

    @Transactional
    public RoadmapItemDto updateItemStatus(User user, UUID itemId, UpdateItemStatusRequest request) {
        var item = roadmapItemRepository.findByIdAndRoadmapUserId(itemId, user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Roadmap item not found"));

        RoadmapItem.Status newStatus;
        try {
            newStatus = RoadmapItem.Status.valueOf(request.status());
        } catch (IllegalArgumentException e) {
            throw new InvalidRequestException("Invalid status: " + request.status()
                    + ". Must be NOT_STARTED, IN_PROGRESS, or COMPLETED");
        }

        item.setStatus(newStatus);
        roadmapItemRepository.save(item);

        return toItemDto(item);
    }

    public int computeCompletion(UUID roadmapId) {
        long total = roadmapItemRepository.countByRoadmapId(roadmapId);
        if (total == 0) return 0;
        long completed = roadmapItemRepository.countByRoadmapIdAndStatus(roadmapId, RoadmapItem.Status.COMPLETED);
        return (int) Math.round(completed * 100.0 / total);
    }

    private RoadmapResponse toResponse(Roadmap roadmap, List<RoadmapItem> items) {
        int completion = computeCompletionFromItems(items);

        List<WeekDto> weeks = items.stream()
                .collect(Collectors.groupingBy(RoadmapItem::getWeekNumber))
                .entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .map(e -> new WeekDto(
                        e.getKey(),
                        e.getValue().stream()
                                .sorted(Comparator.comparingInt(RoadmapItem::getSortOrder))
                                .map(this::toItemDto)
                                .toList()))
                .toList();

        return new RoadmapResponse(
                roadmap.getId(),
                roadmap.getTargetRole(),
                roadmap.getTotalWeeks(),
                roadmap.getRationale(),
                completion,
                weeks);
    }

    private int computeCompletionFromItems(List<RoadmapItem> items) {
        if (items.isEmpty()) return 0;
        long completed = items.stream()
                .filter(i -> i.getStatus() == RoadmapItem.Status.COMPLETED)
                .count();
        return (int) Math.round(completed * 100.0 / items.size());
    }

    private RoadmapItemDto toItemDto(RoadmapItem item) {
        return new RoadmapItemDto(item.getId(), item.getTopicName(), item.getCategory(), item.getStatus().name());
    }
}
