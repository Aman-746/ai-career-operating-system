package com.aman.careeros.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(
        name = "daily_updates",
        uniqueConstraints = @UniqueConstraint(
                name = "uq_daily_update_user_date",
                columnNames = {"user_id", "date"}),
        indexes = @Index(name = "idx_daily_updates_user_date", columnList = "user_id, date"))
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyUpdate {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "roadmap_id", nullable = false)
    private Roadmap roadmap;

    @Column(nullable = false)
    private LocalDate date;

    @Column(name = "total_hours", nullable = false, precision = 4, scale = 1)
    private BigDecimal totalHours;

    @Column(columnDefinition = "text")
    private String notes;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
