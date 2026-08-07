package com.aman.careeros.entity;

import com.aman.careeros.dto.ProgressAnalysisBody;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(
        name = "progress_analyses",
        indexes = @Index(name = "idx_progress_analyses_user", columnList = "user_id, created_at"))
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgressAnalysis {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "roadmap_id", nullable = false)
    private Roadmap roadmap;

    @Column(name = "from_date", nullable = false)
    private LocalDate fromDate;

    @Column(name = "to_date", nullable = false)
    private LocalDate toDate;

    @Column(name = "updates_count", nullable = false)
    private Integer updatesCount;

    @Column(name = "total_hours", nullable = false, precision = 5, scale = 1)
    private BigDecimal totalHours;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private ProgressAnalysisBody analysis;

    @Column(name = "model_id", length = 60)
    private String modelId;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
