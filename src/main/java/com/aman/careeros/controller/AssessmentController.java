package com.aman.careeros.controller;

import com.aman.careeros.dto.AssessmentIntroResponse;
import com.aman.careeros.entity.User;
import com.aman.careeros.service.AssessmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
}
