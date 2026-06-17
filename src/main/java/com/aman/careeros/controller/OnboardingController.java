package com.aman.careeros.controller;

import com.aman.careeros.dto.OnboardingProfileRequest;
import com.aman.careeros.dto.OnboardingProfileResponse;
import com.aman.careeros.dto.OnboardingStatusResponse;
import com.aman.careeros.dto.ResumeUploadResponse;
import com.aman.careeros.entity.User;
import com.aman.careeros.service.OnboardingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * OnboardingController - REST API for the post-registration onboarding flow
 * (target role/company/timeline/experience, plus the mandatory resume upload).
 *
 * All routes here require authentication; SecurityConfig already protects
 * anything outside "/api/auth/**" so no extra wiring is needed.
 */
@RestController
@RequestMapping("/api/onboarding")
@RequiredArgsConstructor
public class OnboardingController {

    private final OnboardingService onboardingService;

    /**
     * POST /api/onboarding/profile
     * Creates the profile on first call, updates it on subsequent calls.
     */
    @PostMapping("/profile")
    public ResponseEntity<OnboardingProfileResponse> saveProfile(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody OnboardingProfileRequest request) {
        return ResponseEntity.ok(onboardingService.saveProfile(user, request));
    }

    /**
     * GET /api/onboarding/profile
     */
    @GetMapping("/profile")
    public ResponseEntity<OnboardingProfileResponse> getProfile(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(onboardingService.getProfile(user));
    }

    /**
     * POST /api/onboarding/resume (multipart/form-data, field name "file")
     * Marks onboarding COMPLETED on success.
     */
    @PostMapping(value = "/resume", consumes = "multipart/form-data")
    public ResponseEntity<ResumeUploadResponse> uploadResume(
            @AuthenticationPrincipal User user,
            @RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok(onboardingService.uploadResume(user, file));
    }

    /**
     * GET /api/onboarding/resume
     */
    @GetMapping("/resume")
    public ResponseEntity<ResumeUploadResponse> getResume(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(onboardingService.getResume(user));
    }

    /**
     * GET /api/onboarding/status
     * Used right after login to decide whether to redirect into onboarding or the dashboard.
     */
    @GetMapping("/status")
    public ResponseEntity<OnboardingStatusResponse> getStatus(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(onboardingService.getStatus(user));
    }
}
