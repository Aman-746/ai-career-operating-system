package com.aman.careeros.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(
        name = "daily_update_items",
        indexes = @Index(name = "idx_daily_update_items_update", columnList = "daily_update_id"))
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyUpdateItem {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "daily_update_id", nullable = false)
    private DailyUpdate dailyUpdate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "roadmap_item_id", nullable = false)
    private RoadmapItem roadmapItem;

    @Column(nullable = false, precision = 4, scale = 1)
    private BigDecimal hours;
}
