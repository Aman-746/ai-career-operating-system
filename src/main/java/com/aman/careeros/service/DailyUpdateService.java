package com.aman.careeros.service;

import com.aman.careeros.ai.ProgressAnalysisClient;
import com.aman.careeros.dto.DailyUpdateItemRequest;
import com.aman.careeros.dto.DailyUpdateItemResponse;
import com.aman.careeros.dto.DailyUpdateRequest;
import com.aman.careeros.dto.DailyUpdateResponse;
import com.aman.careeros.dto.ProgressAnalysisAiRequest;
import com.aman.careeros.dto.ProgressAnalysisAiResponse;
import com.aman.careeros.dto.ProgressAnalysisResponse;
import com.aman.careeros.entity.DailyUpdate;
import com.aman.careeros.entity.DailyUpdateItem;
import com.aman.careeros.entity.ProgressAnalysis;
import com.aman.careeros.entity.Roadmap;
import com.aman.careeros.entity.RoadmapItem;
import com.aman.careeros.entity.User;
import com.aman.careeros.exception.InvalidRequestException;
import com.aman.careeros.exception.ResourceAlreadyExistsException;
import com.aman.careeros.exception.ResourceNotFoundException;
import com.aman.careeros.repository.DailyUpdateItemRepository;
import com.aman.careeros.repository.DailyUpdateRepository;
import com.aman.careeros.repository.ProgressAnalysisRepository;
import com.aman.careeros.repository.RoadmapItemRepository;
import com.aman.careeros.repository.RoadmapRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class DailyUpdateService {

    private static final int ANALYSIS_THRESHOLD = 3;

    private final RoadmapRepository roadmapRepository;
    private final RoadmapItemRepository roadmapItemRepository;
    private final DailyUpdateRepository dailyUpdateRepository;
    private final DailyUpdateItemRepository dailyUpdateItemRepository;
    private final ProgressAnalysisRepository progressAnalysisRepository;
    private final ProgressAnalysisClient progressAnalysisClient;

    @Transactional
    public DailyUpdateResponse save(User user, DailyUpdateRequest request) {
        Roadmap roadmap = roadmapRepository.findByUserIdAndStatus(user.getId(), Roadmap.Status.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("No active roadmap found. Generate a roadmap first."));

        if (request.date().isAfter(LocalDate.now())) {
            throw new InvalidRequestException("Cannot log a daily update for a future date");
        }

        if (dailyUpdateRepository.findByUserIdAndDate(user.getId(), request.date()).isPresent()) {
            throw new ResourceAlreadyExistsException(
                    "You already have an update for " + request.date() + ". Use PUT to edit it.");
        }

        Map<UUID, RoadmapItem> itemsById = resolveRoadmapItems(roadmap.getId(), request.items());

        DailyUpdate update = dailyUpdateRepository.save(DailyUpdate.builder()
                .user(user)
                .roadmap(roadmap)
                .date(request.date())
                .totalHours(request.totalHours())
                .notes(request.notes())
                .build());

        List<DailyUpdateItem> savedItems = saveItems(update, request.items(), itemsById);
        return toResponse(update, savedItems);
    }

    @Transactional
    public DailyUpdateResponse update(User user, LocalDate date, DailyUpdateRequest request) {
        if (!date.equals(request.date())) {
            throw new InvalidRequestException("Date in URL must match date in request body");
        }

        DailyUpdate existing = dailyUpdateRepository.findByUserIdAndDate(user.getId(), date)
                .orElseThrow(() -> new ResourceNotFoundException("No update found for " + date));

        Roadmap roadmap = roadmapRepository.findByUserIdAndStatus(user.getId(), Roadmap.Status.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("No active roadmap found"));

        Map<UUID, RoadmapItem> itemsById = resolveRoadmapItems(roadmap.getId(), request.items());

        existing.setTotalHours(request.totalHours());
        existing.setNotes(request.notes());
        dailyUpdateRepository.save(existing);

        dailyUpdateItemRepository.deleteAllByDailyUpdateId(existing.getId());
        List<DailyUpdateItem> savedItems = saveItems(existing, request.items(), itemsById);

        return toResponse(existing, savedItems);
    }

    @Transactional(readOnly = true)
    public List<DailyUpdateResponse> list(User user) {
        List<DailyUpdate> updates = dailyUpdateRepository.findAllByUserIdOrderByDateDesc(user.getId());
        return updates.stream().map(u -> {
            List<DailyUpdateItem> items = dailyUpdateItemRepository.findAllByDailyUpdateId(u.getId());
            return toResponse(u, items);
        }).toList();
    }

    @Transactional(readOnly = true)
    public DailyUpdateResponse getByDate(User user, LocalDate date) {
        DailyUpdate update = dailyUpdateRepository.findByUserIdAndDate(user.getId(), date)
                .orElseThrow(() -> new ResourceNotFoundException("No update found for " + date));
        List<DailyUpdateItem> items = dailyUpdateItemRepository.findAllByDailyUpdateId(update.getId());
        return toResponse(update, items);
    }

    /**
     * Returns the latest progress analysis, or generates a new one if 3+ new
     * daily updates have been logged since the last analysis. Returns
     * INSUFFICIENT_DATA when fewer than 3 new updates exist.
     */
    @Transactional
    public ProgressAnalysisResponse getOrGenerateAnalysis(User user) {
        Roadmap roadmap = roadmapRepository.findByUserIdAndStatus(user.getId(), Roadmap.Status.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("No active roadmap found"));

        Optional<ProgressAnalysis> latestOpt = progressAnalysisRepository
                .findTopByUserIdOrderByCreatedAtDesc(user.getId());

        long newUpdatesCount;
        List<DailyUpdate> updatesForAnalysis;

        if (latestOpt.isPresent()) {
            LocalDate lastAnalyzedDate = latestOpt.get().getToDate();
            newUpdatesCount = dailyUpdateRepository.countByUserIdAndDateAfter(user.getId(), lastAnalyzedDate);
            updatesForAnalysis = dailyUpdateRepository
                    .findAllByUserIdAndDateAfterOrderByDateAsc(user.getId(), lastAnalyzedDate);
        } else {
            newUpdatesCount = dailyUpdateRepository.countByUserId(user.getId());
            updatesForAnalysis = dailyUpdateRepository
                    .findAllByUserIdAndDateAfterOrderByDateAsc(user.getId(), LocalDate.of(2000, 1, 1));
        }

        if (newUpdatesCount < ANALYSIS_THRESHOLD) {
            if (latestOpt.isPresent()) {
                // Still return the existing analysis — it's fresh enough
                return toAnalysisResponse(latestOpt.get());
            }
            int needed = (int) (ANALYSIS_THRESHOLD - newUpdatesCount);
            return new ProgressAnalysisResponse("INSUFFICIENT_DATA", needed,
                    null, null, null, null, null, null, null);
        }

        // Generate new analysis
        return generateAnalysis(user, roadmap, updatesForAnalysis);
    }

    // --- private helpers ---

    private ProgressAnalysisResponse generateAnalysis(
            User user, Roadmap roadmap, List<DailyUpdate> updates) {

        List<RoadmapItem> allItems =
                roadmapItemRepository.findAllByRoadmapIdOrderByWeekNumberAscSortOrderAsc(roadmap.getId());

        // Fetch items for each update
        Map<UUID, List<DailyUpdateItem>> itemsByUpdateId = updates.stream()
                .collect(Collectors.toMap(
                        DailyUpdate::getId,
                        u -> dailyUpdateItemRepository.findAllByDailyUpdateId(u.getId())));

        List<ProgressAnalysisAiRequest.UpdateSummary> updateSummaries = updates.stream()
                .map(u -> {
                    List<DailyUpdateItem> duItems = itemsByUpdateId.getOrDefault(u.getId(), List.of());
                    List<ProgressAnalysisAiRequest.TopicSummary> topics = duItems.stream()
                            .map(i -> new ProgressAnalysisAiRequest.TopicSummary(
                                    i.getRoadmapItem().getTopicName(),
                                    i.getRoadmapItem().getCategory(),
                                    i.getHours()))
                            .toList();
                    return new ProgressAnalysisAiRequest.UpdateSummary(
                            u.getDate().toString(), u.getTotalHours(), u.getNotes(), topics);
                })
                .toList();

        List<ProgressAnalysisAiRequest.RoadmapItemSummary> itemSummaries = allItems.stream()
                .map(i -> new ProgressAnalysisAiRequest.RoadmapItemSummary(
                        i.getTopicName(), i.getCategory(), i.getStatus().name()))
                .toList();

        // Pass original gaps from session gap analysis (via roadmap rationale — simplified for V1)
        ProgressAnalysisAiRequest aiRequest = new ProgressAnalysisAiRequest(
                roadmap.getTargetRole(),
                roadmap.getRationale(),
                roadmap.getTotalWeeks(),
                updateSummaries,
                itemSummaries,
                List.of());

        ProgressAnalysisAiResponse aiResponse = progressAnalysisClient.analyze(aiRequest);

        BigDecimal totalHours = updates.stream()
                .map(DailyUpdate::getTotalHours)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        LocalDate fromDate = updates.getFirst().getDate();
        LocalDate toDate = updates.getLast().getDate();

        ProgressAnalysis saved = progressAnalysisRepository.save(ProgressAnalysis.builder()
                .user(user)
                .roadmap(roadmap)
                .fromDate(fromDate)
                .toDate(toDate)
                .updatesCount(updates.size())
                .totalHours(totalHours)
                .analysis(aiResponse.analysis())
                .modelId(aiResponse.modelMeta() != null ? aiResponse.modelMeta().modelId() : null)
                .build());

        return toAnalysisResponse(saved);
    }

    private Map<UUID, RoadmapItem> resolveRoadmapItems(UUID roadmapId, List<DailyUpdateItemRequest> itemRequests) {
        List<UUID> ids = itemRequests.stream().map(DailyUpdateItemRequest::roadmapItemId).toList();
        Map<UUID, RoadmapItem> byId = roadmapItemRepository.findAllById(ids)
                .stream()
                .collect(Collectors.toMap(RoadmapItem::getId, r -> r));

        for (UUID id : ids) {
            RoadmapItem item = byId.get(id);
            if (item == null) {
                throw new ResourceNotFoundException("Roadmap item not found: " + id);
            }
            if (!item.getRoadmap().getId().equals(roadmapId)) {
                throw new InvalidRequestException("Roadmap item " + id + " does not belong to your active roadmap");
            }
        }
        return byId;
    }

    private List<DailyUpdateItem> saveItems(
            DailyUpdate update, List<DailyUpdateItemRequest> requests, Map<UUID, RoadmapItem> byId) {
        List<DailyUpdateItem> items = requests.stream()
                .map(req -> DailyUpdateItem.builder()
                        .dailyUpdate(update)
                        .roadmapItem(byId.get(req.roadmapItemId()))
                        .hours(req.hours())
                        .build())
                .toList();
        return dailyUpdateItemRepository.saveAll(items);
    }

    private DailyUpdateResponse toResponse(DailyUpdate update, List<DailyUpdateItem> items) {
        List<DailyUpdateItemResponse> itemDtos = items.stream()
                .map(i -> new DailyUpdateItemResponse(
                        i.getId(),
                        i.getRoadmapItem().getId(),
                        i.getRoadmapItem().getTopicName(),
                        i.getRoadmapItem().getCategory(),
                        i.getHours()))
                .toList();
        return new DailyUpdateResponse(
                update.getId(), update.getDate(), update.getTotalHours(),
                update.getNotes(), itemDtos, update.getCreatedAt());
    }

    private ProgressAnalysisResponse toAnalysisResponse(ProgressAnalysis pa) {
        return new ProgressAnalysisResponse(
                "READY", null,
                pa.getId(), pa.getFromDate(), pa.getToDate(),
                pa.getUpdatesCount(), pa.getTotalHours(),
                pa.getAnalysis(), pa.getCreatedAt());
    }
}
