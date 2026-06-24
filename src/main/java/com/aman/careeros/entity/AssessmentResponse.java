package com.aman.careeros.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * AssessmentResponse Entity - Represents the 'assessment_responses' table.
 *
 * topic is denormalized from Question to avoid a join at scoring time.
 * Scoring groups responses by this column with a single-table query.
 *
 * is_correct is computed at submit time from the Question's correct_option_id
 * and persisted here so scoring is a simple aggregate over this table.
 */
@Entity
@Table(
        name = "assessment_responses",
        indexes = {
                @Index(name = "idx_assessment_responses_session",
                        columnList = "session_id")
        },
        uniqueConstraints = {
                @UniqueConstraint(name = "uq_response_session_question",
                        columnNames = {"session_id", "question_id"})
        })
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AssessmentResponse {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id", nullable = false)
    private AssessmentSession session;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    private Question question;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 100)
    private AssessmentTopic topic;

    @Column(name = "selected_option_id", nullable = false, length = 8)
    private String selectedOptionId;

    @Column(name = "is_correct", nullable = false)
    private boolean correct;
}
