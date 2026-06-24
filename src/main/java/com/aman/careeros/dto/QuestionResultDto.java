package com.aman.careeros.dto;

import com.aman.careeros.entity.AssessmentTopic;
import com.aman.careeros.entity.Question;

import java.util.List;
import java.util.UUID;

/**
 * QuestionResultDto - Per-question breakdown shown on the results screen.
 * correctOptionId and explanation are intentionally included here (unlike
 * QuestionDto) because the assessment is already completed at this point.
 */
public record QuestionResultDto(
        UUID questionId,
        AssessmentTopic topic,
        Question.Difficulty difficulty,
        String stem,
        List<Question.QuestionOption> options,
        String selectedOptionId,
        String correctOptionId,
        boolean correct,
        String explanation
) {}
