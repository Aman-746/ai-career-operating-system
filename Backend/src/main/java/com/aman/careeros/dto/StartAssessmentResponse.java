package com.aman.careeros.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StartAssessmentResponse {
    private UUID sessionId;
    private String targetRole;
    private int totalQuestions;
    private int estimatedMinutes;
    private List<QuestionDto> questions;
}
