package com.aman.careeros.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record DailyUpdateRequest(
        @NotNull LocalDate date,
        @NotNull @DecimalMin("0.5") @DecimalMax("24.0") BigDecimal totalHours,
        String notes,
        @NotEmpty @Valid List<DailyUpdateItemRequest> items) {}
