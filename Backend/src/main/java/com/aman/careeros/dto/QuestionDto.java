package com.aman.careeros.dto;

import com.aman.careeros.entity.AssessmentTopic;
import com.aman.careeros.entity.Question;

import java.util.List;
import java.util.UUID;

/**
 * QuestionDto - Client-safe projection of Question.
 * correctOptionId and explanation are intentionally omitted.
 */
public record QuestionDto(
        UUID id,
        AssessmentTopic topic,
        Question.Difficulty difficulty,
        String stem,
        List<Question.QuestionOption> options
) {
    public static QuestionDto from(Question q) {
        return new QuestionDto(q.getId(), q.getTopic(), q.getDifficulty(), q.getStem(), q.getOptions());
    }
}
