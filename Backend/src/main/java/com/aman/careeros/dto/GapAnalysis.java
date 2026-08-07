package com.aman.careeros.dto;

import java.util.List;

/**
 * GapAnalysis - The AI-generated, structured skill-gap analysis for a session.
 *
 * This is both the persisted value object (stored as JSONB on AssessmentSession)
 * and the shape returned to the frontend, so its field names are a stable
 * contract shared by the model's responseSchema, the database, and the UI.
 *
 * All fields are Strings (enums are validated at the service layer, not typed
 * here) so the record serialises cleanly to JSONB without any Java-time or
 * polymorphism concerns — mirroring the existing TopicScore record.
 *
 * modelMeta is stamped server-side after the call; the model never populates it.
 */
public record GapAnalysis(
        String readinessLevel,
        String readinessSummary,
        List<Strength> strengths,
        List<Gap> gaps,
        ModelMeta modelMeta) {

    /** A genuine strength to reinforce, grounded in resume and/or a STRONG score. */
    public record Strength(String area, String evidence) {
    }

    /**
     * A gap that would hurt the candidate in an interview for the target role.
     *
     * severity:       CRITICAL | MODERATE | MINOR
     * evidenceSource: RESUME_ONLY | ASSESSMENT_ONLY | BOTH (BOTH = credibility gap)
     */
    public record Gap(
            String area,
            String severity,
            String evidenceSource,
            String insight,
            String recommendation) {
    }

    /** Provenance, stamped by the server — never trusted from the model. */
    public record ModelMeta(String modelId, String generatedAt) {
    }
}
