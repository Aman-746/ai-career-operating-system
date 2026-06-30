package com.aman.careeros.dto;

import java.util.List;

/**
 * AI-generated analysis body. Stored as JSONB in progress_analyses and
 * returned directly to the frontend — field names are a shared contract
 * between the Python response schema, the database, and the UI.
 */
public record ProgressAnalysisBody(
        String summary,
        List<String> strengths,
        List<String> areasToImprove,
        List<String> recommendedFocus,
        String hoursPaceComment,
        ModelMeta modelMeta) {

    public record ModelMeta(String modelId, String generatedAt) {}
}
