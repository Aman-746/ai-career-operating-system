package com.aman.careeros.repository;

import com.aman.careeros.entity.ProgressAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ProgressAnalysisRepository extends JpaRepository<ProgressAnalysis, UUID> {

    Optional<ProgressAnalysis> findTopByUserIdOrderByCreatedAtDesc(UUID userId);
}
