package com.aman.careeros.controller;

import com.aman.careeros.dto.AssessmentIntroResponse;
import com.aman.careeros.dto.AssessmentResultResponse;
import com.aman.careeros.dto.StartAssessmentResponse;
import com.aman.careeros.dto.SubmitAnswersRequest;
import com.aman.careeros.dto.SubmitAssessmentResponse;
import com.aman.careeros.entity.User;
import com.aman.careeros.service.AssessmentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

/**
 * AssessmentController - REST API for the assessment module.
 *
 * All routes require authentication; SecurityConfig already protects
 * anything outside "/api/auth/**" so no extra wiring is needed.
 */
@RestController
@RequestMapping("/api/assessment")
@RequiredArgsConstructor
public class AssessmentController {

    private final AssessmentService assessmentService;

    /**
     * GET /api/assessment/intro
     * Returns the data needed to render the Assessment Introduction page:
     * profile summary, resume analysis results, and the role-based assessment config.
     */
    @GetMapping("/intro")
    public ResponseEntity<AssessmentIntroResponse> getIntro(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(assessmentService.getIntro(user));
    }

    /**
     * POST /api/assessment/start
     * Creates a new assessment session for the authenticated user, or resumes
     * an existing IN_PROGRESS session. Returns the full frozen question list
     * so the frontend can paginate locally (6 questions per topic page).
     */
    @PostMapping("/start")
    public ResponseEntity<StartAssessmentResponse> start(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(assessmentService.startAssessment(user));
    }

    /**
     * POST /api/assessment/submit
     * Accepts the full set of answers for an IN_PROGRESS session, scores each
     * topic, and marks the session COMPLETED. Returns the sessionId so the
     * client can redirect to GET /result/{sessionId}.
     */
    @PostMapping("/submit")
    public ResponseEntity<SubmitAssessmentResponse> submit(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody SubmitAnswersRequest request) {
        return ResponseEntity.ok(assessmentService.submitAssessment(user, request));
    }

    /**
     * GET /api/assessment/result/{sessionId}
     * Returns the full scored result for a COMPLETED session, including
     * per-question breakdowns with correct answers and explanations revealed.
     * Only the session's owner can access it.
     */
    @GetMapping("/result/{sessionId}")
    public ResponseEntity<AssessmentResultResponse> getResult(
            @AuthenticationPrincipal User user,
            @PathVariable UUID sessionId) {
        return ResponseEntity.ok(assessmentService.getResult(user, sessionId));
    }
}
