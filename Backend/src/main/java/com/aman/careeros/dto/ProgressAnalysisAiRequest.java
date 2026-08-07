package com.aman.careeros.dto;

import java.math.BigDecimal;
import java.util.List;

public record ProgressAnalysisAiRequest(
        String targetRole,
        String roadmapRationale,
        int totalWeeks,
        List<UpdateSummary> updates,
        List<RoadmapItemSummary> roadmapItems,
        List<GapSummary> gaps) {

    public record UpdateSummary(
            String date,
            BigDecimal totalHours,
            String notes,
            List<TopicSummary> topics) {}

    public record TopicSummary(
            String topicName,
            String category,
            BigDecimal hours) {}

    public record RoadmapItemSummary(
            String topicName,
            String category,
            String status) {}

    public record GapSummary(
            String area,
            String severity) {}
}
