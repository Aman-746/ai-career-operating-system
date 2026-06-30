package com.aman.careeros.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.util.UUID;

public record DailyUpdateItemRequest(
        @NotNull UUID roadmapItemId,
        @NotNull @DecimalMin("0.0") BigDecimal hours) {}
