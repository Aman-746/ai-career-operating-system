package com.aman.careeros.dto;

public record ProgressAnalysisAiResponse(
        ProgressAnalysisBody analysis,
        ModelMeta modelMeta) {

    public record ModelMeta(String modelId, String generatedAt) {}
}
