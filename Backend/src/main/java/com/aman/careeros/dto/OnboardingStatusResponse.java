package com.aman.careeros.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * OnboardingStatusResponse - Tells the frontend whether onboarding is complete,
 * so it knows whether to redirect into the onboarding flow or the dashboard.
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OnboardingStatusResponse {
    private boolean completed;
    private OnboardingProfileResponse profile;
}
