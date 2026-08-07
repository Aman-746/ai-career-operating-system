package com.aman.careeros.config;

import com.aman.careeros.entity.AssessmentTopic;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.aman.careeros.entity.AssessmentTopic.*;

/**
 * AssessmentRoleConfig - Maps each launch role to its assessment configuration.
 *
 * Topics are derived from the targetRole only (Phase-1 design decision). The
 * current role is stored in OnboardingProfile for future gap analysis but does
 * not affect the assessment topic set in this version.
 *
 * Availability model: ROLE_CONFIGS contains ONLY the launch roles. A role is
 * assessable iff a config is present for it; {@link #getConfig} returns an empty
 * Optional for every other role string (known non-launch role or unexpected
 * free text), which the caller renders as a "coming soon" state. There is no
 * silent DEFAULT fallback — an honest "coming soon" beats a misleading generic
 * assessment.
 *
 * Reuse rule: a fixed 6 questions per topic, so every topic carries the same
 * weight and denominator across roles. Total questionCount = topics * 6.
 */
@Component
public class AssessmentRoleConfig {

    public record TopicConfig(List<AssessmentTopic> topics, int questionCount, int estimatedMinutes) {
    }

    private static final Map<String, TopicConfig> ROLE_CONFIGS = Map.of(

            "Software Engineer", new TopicConfig(
                    List.of(
                            DATA_STRUCTURES_ALGORITHMS,
                            OBJECT_ORIENTED_DESIGN,
                            SYSTEM_DESIGN,
                            DATABASES_AND_SQL,
                            CONCURRENCY_AND_PARALLELISM),
                    30, 20),

            "Backend Engineer", new TopicConfig(
                    List.of(
                            DATA_STRUCTURES_ALGORITHMS,
                            OBJECT_ORIENTED_DESIGN,
                            SYSTEM_DESIGN,
                            DATABASES_AND_SQL,
                            API_AND_WEB_FUNDAMENTALS,
                            CONCURRENCY_AND_PARALLELISM),
                    36, 24),

            "Full Stack Engineer", new TopicConfig(
                    List.of(
                            DATA_STRUCTURES_ALGORITHMS,
                            SYSTEM_DESIGN,
                            DATABASES_AND_SQL,
                            API_AND_WEB_FUNDAMENTALS,
                            FRONTEND_ENGINEERING,
                            JAVASCRIPT_AND_TYPESCRIPT),
                    36, 24),

            "Frontend Engineer", new TopicConfig(
                    List.of(
                            DATA_STRUCTURES_ALGORITHMS,
                            OBJECT_ORIENTED_DESIGN,
                            API_AND_WEB_FUNDAMENTALS,
                            FRONTEND_ENGINEERING,
                            JAVASCRIPT_AND_TYPESCRIPT,
                            TESTING_AND_CODE_QUALITY),
                    36, 24));

    /**
     * Returns the assessment configuration for an assessable launch role, or an
     * empty Optional for any role that is not yet assessable ("coming soon").
     */
    public Optional<TopicConfig> getConfig(String targetRole) {
        return Optional.ofNullable(ROLE_CONFIGS.get(targetRole));
    }

    /**
     * Whether the given target role has an assessment available in this version.
     */
    public boolean isAssessable(String targetRole) {
        return ROLE_CONFIGS.containsKey(targetRole);
    }
}
