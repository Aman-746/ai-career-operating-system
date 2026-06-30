package com.aman.careeros.dto;

import java.util.UUID;

public record RoadmapItemDto(
        UUID id,
        String topicName,
        String category,
        String status) {
}
