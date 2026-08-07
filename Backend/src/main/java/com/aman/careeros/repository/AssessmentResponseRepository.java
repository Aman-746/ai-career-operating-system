package com.aman.careeros.repository;

import com.aman.careeros.entity.AssessmentResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface AssessmentResponseRepository extends JpaRepository<AssessmentResponse, UUID> {

    /**
     * Fetch all responses for a session — used by scoring.
     * topic is denormalized on each row so scoring can group by topic
     * without joining back to the questions table.
     */
    List<AssessmentResponse> findBySessionId(UUID sessionId);
}
