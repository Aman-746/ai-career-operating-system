package com.aman.careeros.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.util.List;
import java.util.UUID;

/**
 * Question Entity - Represents the 'questions' table (the static question bank).
 *
 * topic must match an AssessmentTopic enum name — enforced at the service layer.
 * correct_option_id is never serialized to the client; the sanitized DTO
 * (QuestionDto) is used for all client-facing responses.
 *
 * options JSONB format: [{id: "a", text: "..."}, {id: "b", text: "..."}, ...]
 */
@Entity
@Table(
        name = "questions",
        indexes = {
                @Index(name = "idx_questions_topic_difficulty_active",
                        columnList = "topic, difficulty, active")
        })
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 100)
    private AssessmentTopic topic;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private Difficulty difficulty;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String stem;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false, columnDefinition = "jsonb")
    private List<QuestionOption> options;

    @Column(name = "correct_option_id", nullable = false, length = 8)
    private String correctOptionId;

    @Column(columnDefinition = "TEXT")
    private String explanation;

    @Builder.Default
    @Column(nullable = false)
    private boolean active = true;

    public enum Difficulty {
        EASY, MEDIUM, HARD
    }

    public record QuestionOption(String id, String text) {
    }
}
