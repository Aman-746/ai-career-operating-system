package com.aman.careeros.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record DailyUpdateItemResponse(
        UUID id,
        UUID roadmapItemId,
        String topicName,
        String category,
        BigDecimal hours) {}
