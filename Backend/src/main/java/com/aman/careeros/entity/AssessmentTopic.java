package com.aman.careeros.entity;

/**
 * AssessmentTopic - the shared assessment topic vocabulary (single source of truth).
 *
 * Imported by role config, question-bank tagging, scoring, gap analysis, and
 * (later) roadmap generation. No topic is ever represented as a raw string
 * literal anywhere else in the codebase.
 *
 * The enum NAME is a permanent contract: it is persisted in the
 * {@code questions.topic} / {@code assessment_responses.topic} columns and
 * referenced by the question bank. Never rename a constant — deprecate and add.
 * Display names and descriptions are free to change.
 */
public enum AssessmentTopic {

    DATA_STRUCTURES_ALGORITHMS("Data Structures & Algorithms"),
    OBJECT_ORIENTED_DESIGN("Object-Oriented Design"),
    SYSTEM_DESIGN("System Design"),
    DATABASES_AND_SQL("Databases & SQL"),
    API_AND_WEB_FUNDAMENTALS("API & Web Fundamentals"),
    CONCURRENCY_AND_PARALLELISM("Concurrency & Parallelism"),
    FRONTEND_ENGINEERING("Frontend Engineering"),
    JAVASCRIPT_AND_TYPESCRIPT("JavaScript & TypeScript"),
    TESTING_AND_CODE_QUALITY("Testing & Code Quality");

    private final String displayName;

    AssessmentTopic(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
