package com.aman.careeros.repository;

import com.aman.careeros.entity.AssessmentSession;
import com.aman.careeros.entity.AssessmentSession.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface AssessmentSessionRepository extends JpaRepository<AssessmentSession, UUID> {

    /**
     * Returns the user's current open session, if any.
     * The partial unique index on (user_id WHERE status='IN_PROGRESS') guarantees
     * at most one row is returned.
     */
    Optional<AssessmentSession> findByUserIdAndStatus(UUID userId, Status status);

    /**
     * Ownership check — used by GET /result to prevent cross-user access.
     */
    Optional<AssessmentSession> findByIdAndUserId(UUID id, UUID userId);
}
