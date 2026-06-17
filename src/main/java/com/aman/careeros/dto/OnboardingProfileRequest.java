package com.aman.careeros.dto;

import com.aman.careeros.entity.Timeline;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * OnboardingProfileRequest - Data Transfer Object for creating/updating the onboarding profile.
 */
@Data
public class OnboardingProfileRequest {

    @NotBlank(message = "Current role is required")
    @Size(max = 100, message = "Current role must be under 100 characters")
    private String currentRole;

    @NotBlank(message = "Target role is required")
    @Size(max = 100, message = "Target role must be under 100 characters")
    private String targetRole;

    @Size(max = 150, message = "Target company must be under 150 characters")
    private String targetCompany;

    @NotNull(message = "Timeline is required")
    private Timeline timeline;

    @NotNull(message = "Years of experience is required")
    @Min(value = 0, message = "Years of experience cannot be negative")
    @Max(value = 50, message = "Years of experience must be 50 or less")
    private Integer yearsOfExperience;
}
