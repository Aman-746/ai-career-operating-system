package com.aman.careeros.repository;

import com.aman.careeros.entity.OnboardingProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * OnboardingProfileRepository - Interface for database operations on the OnboardingProfile entity.
 */
@Repository
public interface OnboardingProfileRepository extends JpaRepository<OnboardingProfile, UUID> {

    /**
     * Find the onboarding profile belonging to a given user.
     */
    Optional<OnboardingProfile> findByUserId(UUID userId);
}
