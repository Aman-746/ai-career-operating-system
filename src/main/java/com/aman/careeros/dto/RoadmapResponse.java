package com.aman.careeros.dto;

import java.util.List;
import java.util.UUID;

public record RoadmapResponse(
        UUID roadmapId,
        String targetRole,
        int totalWeeks,
        String rationale,
        int completionPercent,
        List<WeekDto> weeks) {
}
