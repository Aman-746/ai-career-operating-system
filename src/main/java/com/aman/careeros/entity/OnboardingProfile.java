package com.aman.careeros.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * OnboardingProfile Entity - Represents the 'onboarding_profiles' table.
 * One-to-one with User; holds the career-targeting details collected during onboarding.
 */
@Entity
@Table(name = "onboarding_profiles")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OnboardingProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(name = "present_role", nullable = false, length = 100)
    private String currentRole;

    @Column(name = "target_role", nullable = false, length = 100)
    private String targetRole;

    @Column(name = "target_company", length = 150)
    private String targetCompany;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Timeline timeline;

    @Column(name = "years_of_experience", nullable = false)
    private Integer yearsOfExperience;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    @Column(nullable = false, length = 20)
    private OnboardingStatus status = OnboardingStatus.IN_PROGRESS;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}
