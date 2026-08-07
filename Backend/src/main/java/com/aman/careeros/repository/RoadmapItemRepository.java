package com.aman.careeros.repository;

import com.aman.careeros.entity.RoadmapItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface RoadmapItemRepository extends JpaRepository<RoadmapItem, UUID> {

    List<RoadmapItem> findAllByRoadmapIdOrderByWeekNumberAscSortOrderAsc(UUID roadmapId);

    long countByRoadmapId(UUID roadmapId);

    long countByRoadmapIdAndStatus(UUID roadmapId, RoadmapItem.Status status);

    Optional<RoadmapItem> findByIdAndRoadmapUserId(UUID id, UUID userId);
}
