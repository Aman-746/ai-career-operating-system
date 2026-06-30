package com.aman.careeros.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

public record ProgressAnalysisResponse(
        String status,           // INSUFFICIENT_DATA | READY
        Integer updatesNeeded,   // non-null when INSUFFICIENT_DATA
        UUID analysisId,
        LocalDate fromDate,
        LocalDate toDate,
        Integer updatesCount,
        BigDecimal totalHours,
        ProgressAnalysisBody analysis,
        LocalDateTime generatedAt) {}
