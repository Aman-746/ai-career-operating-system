package com.aman.careeros.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(
        name = "roadmaps",
        indexes = {
                @Index(name = "idx_roadmaps_user_status", columnList = "user_id, status")
        })
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Roadmap {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "target_role", nullable = false, length = 100)
    private String targetRole;

    @Column(name = "total_weeks", nullable = false)
    private Integer totalWeeks;

    @Column(columnDefinition = "text")
    private String rationale;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private Status status = Status.ACTIVE;

    @Column(name = "model_id", length = 60)
    private String modelId;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public enum Status {
        ACTIVE, ARCHIVED
    }
}
