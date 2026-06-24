package com.aman.careeros.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * AssessmentSession Entity - Represents the 'assessment_sessions' table.
 *
 * question_ids stores the ordered frozen plan of served question UUIDs.
 * Freezing prevents a bank edit mid-session from changing what the user sees.
 *
 * topic_scores is null until /submit completes scoring.
 * result is reserved for future LLM-generated analysis and roadmap data.
 *
 * The partial unique index (user_id WHERE status='IN_PROGRESS') enforces one
 * open session per user at the DB level. It is created via a startup SQL script
 * because JPA @Index does not support partial indexes.
 */
@Entity
@Table(
        name = "assessment_sessions",
        indexes = {
                @Index(name = "idx_assessment_sessions_user_status",
                        columnList = "user_id, status")
        })
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AssessmentSession {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "target_role", nullable = false, length = 150)
    private String targetRole;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 15)
    private Status status;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "question_ids", nullable = false, columnDefinition = "jsonb")
    private List<UUID> questionIds;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "topic_scores", columnDefinition = "jsonb")
    private List<TopicScore> topicScores;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private Object result;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    public enum Status {
        IN_PROGRESS, COMPLETED
    }

    public record TopicScore(
            String topic,
            String topicDisplayName,
            int asked,
            int correct,
            int score,
            String band) {
    }
}
