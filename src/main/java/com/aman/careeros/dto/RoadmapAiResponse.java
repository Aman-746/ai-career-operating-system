package com.aman.careeros.dto;

import java.util.List;

public record RoadmapAiResponse(
        List<WeekPlan> weeks,
        String rationale,
        ModelMeta modelMeta) {

    public record WeekPlan(int weekNumber, List<ItemPlan> items) {
    }

    public record ItemPlan(String topicName, String category) {
    }

    public record ModelMeta(String modelId, String generatedAt) {
    }
}
