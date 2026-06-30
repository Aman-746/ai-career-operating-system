package com.aman.careeros.repository;

import com.aman.careeros.entity.Roadmap;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface RoadmapRepository extends JpaRepository<Roadmap, UUID> {

    Optional<Roadmap> findByUserIdAndStatus(UUID userId, Roadmap.Status status);
}
