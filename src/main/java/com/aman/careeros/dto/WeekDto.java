package com.aman.careeros.dto;

import java.util.List;

public record WeekDto(
        int weekNumber,
        List<RoadmapItemDto> items) {
}
