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
        name = "roadmap_items",
        indexes = {
                @Index(name = "idx_roadmap_items_roadmap", columnList = "roadmap_id, week_number")
        })
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RoadmapItem {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "roadmap_id", nullable = false)
    private Roadmap roadmap;

    @Column(name = "week_number", nullable = false)
    private Integer weekNumber;

    @Column(name = "topic_name", nullable = false, length = 150)
    private String topicName;

    @Column(nullable = false, length = 60)
    private String category;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private Status status = Status.NOT_STARTED;

    @Column(name = "sort_order", nullable = false)
    @Builder.Default
    private Integer sortOrder = 0;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public enum Status {
        NOT_STARTED, IN_PROGRESS, COMPLETED
    }
}
