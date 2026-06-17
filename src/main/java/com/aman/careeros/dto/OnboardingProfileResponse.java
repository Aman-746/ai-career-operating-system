package com.aman.careeros.dto;

import com.aman.careeros.entity.OnboardingStatus;
import com.aman.careeros.entity.Timeline;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * OnboardingProfileResponse - The response body returned for onboarding profile reads/writes.
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OnboardingProfileResponse {
    private UUID id;
    private String currentRole;
    private String targetRole;
    private String targetCompany;
    private Timeline timeline;
    private Integer yearsOfExperience;
    private OnboardingStatus status;
    private boolean resumeUploaded;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
