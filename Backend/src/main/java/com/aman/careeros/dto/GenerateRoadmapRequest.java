package com.aman.careeros.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;

public record GenerateRoadmapRequest(
        @NotBlank String targetRole,
        @Min(1) @Max(52) int totalWeeks) {
}
