package com.aman.careeros.entity;

/**
 * OnboardingStatus - Tracks whether a user has finished the onboarding flow.
 * Only flips to COMPLETED once both the profile fields and resume are saved.
 */
public enum OnboardingStatus {
    IN_PROGRESS,
    COMPLETED
}
