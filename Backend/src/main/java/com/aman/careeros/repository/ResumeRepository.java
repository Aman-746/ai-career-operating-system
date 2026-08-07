package com.aman.careeros.repository;

import com.aman.careeros.entity.Resume;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * ResumeRepository - Interface for database operations on the Resume entity.
 */
@Repository
public interface ResumeRepository extends JpaRepository<Resume, UUID> {

    /**
     * Find the most recently uploaded resume for a user.
     */
    Optional<Resume> findTopByUserIdOrderByUploadedAtDesc(UUID userId);

    boolean existsByUserId(UUID userId);
}
