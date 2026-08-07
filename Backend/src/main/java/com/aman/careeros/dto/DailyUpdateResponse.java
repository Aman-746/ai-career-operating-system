package com.aman.careeros.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public record DailyUpdateResponse(
        UUID id,
        LocalDate date,
        BigDecimal totalHours,
        String notes,
        List<DailyUpdateItemResponse> items,
        LocalDateTime createdAt) {}
