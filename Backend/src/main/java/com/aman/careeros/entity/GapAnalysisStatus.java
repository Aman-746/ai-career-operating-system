package com.aman.careeros.entity;

/**
 * GapAnalysisStatus - Lifecycle of a session's AI gap analysis.
 *
 * NONE       never attempted (or feature disabled when the session completed)
 * GENERATING a model call is in flight (reserved for the async upgrade path)
 * READY      analysis is present in gap_analysis and can be served from cache
 * FAILED     a previous attempt failed; the result page falls back to scores
 *
 * A null column value is treated as NONE for backwards compatibility with
 * sessions completed before this feature existed.
 */
public enum GapAnalysisStatus {
    NONE, GENERATING, READY, FAILED
}
