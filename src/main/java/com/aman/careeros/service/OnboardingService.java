package com.aman.careeros.service;

import com.aman.careeros.dto.OnboardingProfileRequest;
import com.aman.careeros.dto.OnboardingProfileResponse;
import com.aman.careeros.dto.OnboardingStatusResponse;
import com.aman.careeros.dto.ResumeUploadResponse;
import com.aman.careeros.entity.OnboardingProfile;
import com.aman.careeros.entity.OnboardingStatus;
import com.aman.careeros.entity.Resume;
import com.aman.careeros.entity.User;
import com.aman.careeros.exception.InvalidRequestException;
import com.aman.careeros.exception.ResourceNotFoundException;
import com.aman.careeros.repository.OnboardingProfileRepository;
import com.aman.careeros.repository.ResumeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * OnboardingService - Handles business logic for the onboarding flow.
 *
 * Resume upload is mandatory to finish onboarding: saving the profile alone
 * keeps status IN_PROGRESS, and only a successful resume upload (which
 * requires a profile to already exist) flips status to COMPLETED.
 */
@Service
@RequiredArgsConstructor
public class OnboardingService {

    private static final long MAX_RESUME_SIZE_BYTES = 5L * 1024 * 1024; // 5MB

    private static final Map<String, String> ALLOWED_RESUME_TYPES = Map.of(
            "application/pdf", ".pdf",
            "application/msword", ".doc",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document", ".docx"
    );

    private final OnboardingProfileRepository onboardingProfileRepository;
    private final ResumeRepository resumeRepository;
    private final FileStorageService fileStorageService;

    /**
     * Creates the onboarding profile on first call, or updates it on subsequent calls.
     */
    public OnboardingProfileResponse saveProfile(User user, OnboardingProfileRequest request) {
        OnboardingProfile profile = onboardingProfileRepository.findByUserId(user.getId())
                .orElseGet(() -> OnboardingProfile.builder().user(user).build());

        profile.setCurrentRole(request.getCurrentRole());
        profile.setTargetRole(request.getTargetRole());
        profile.setTargetCompany(request.getTargetCompany());
        profile.setTimeline(request.getTimeline());
        profile.setYearsOfExperience(request.getYearsOfExperience());

        onboardingProfileRepository.save(profile);

        return toProfileResponse(profile);
    }

    public OnboardingProfileResponse getProfile(User user) {
        OnboardingProfile profile = onboardingProfileRepository.findByUserId(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Onboarding profile not found"));
        return toProfileResponse(profile);
    }

    /**
     * Uploads (or replaces) the user's resume and marks onboarding COMPLETED.
     * Requires the onboarding profile to already exist.
     */
    public ResumeUploadResponse uploadResume(User user, MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new InvalidRequestException("Resume file is required");
        }
        if (file.getSize() > MAX_RESUME_SIZE_BYTES) {
            throw new InvalidRequestException("Resume file must not exceed 5MB");
        }
        String extension = ALLOWED_RESUME_TYPES.get(file.getContentType());
        if (extension == null) {
            throw new InvalidRequestException("Resume must be a PDF, DOC, or DOCX file");
        }

        OnboardingProfile profile = onboardingProfileRepository.findByUserId(user.getId())
                .orElseThrow(() -> new InvalidRequestException("Please complete your profile before uploading a resume"));

        String storagePath = fileStorageService.store(file, user.getId(), extension);

        Resume resume = Resume.builder()
                .user(user)
                .originalFilename(file.getOriginalFilename())
                .storagePath(storagePath)
                .contentType(file.getContentType())
                .fileSizeBytes(file.getSize())
                .build();
        resumeRepository.save(resume);

        profile.setStatus(OnboardingStatus.COMPLETED);
        onboardingProfileRepository.save(profile);

        return toResumeResponse(resume);
    }

    public ResumeUploadResponse getResume(User user) {
        Resume resume = resumeRepository.findTopByUserIdOrderByUploadedAtDesc(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("No resume uploaded yet"));
        return toResumeResponse(resume);
    }

    public OnboardingStatusResponse getStatus(User user) {
        return onboardingProfileRepository.findByUserId(user.getId())
                .map(profile -> OnboardingStatusResponse.builder()
                        .completed(profile.getStatus() == OnboardingStatus.COMPLETED)
                        .profile(toProfileResponse(profile))
                        .build())
                .orElseGet(() -> OnboardingStatusResponse.builder()
                        .completed(false)
                        .profile(null)
                        .build());
    }

    private OnboardingProfileResponse toProfileResponse(OnboardingProfile profile) {
        boolean resumeUploaded = resumeRepository.existsByUserId(profile.getUser().getId());
        return OnboardingProfileResponse.builder()
                .id(profile.getId())
                .currentRole(profile.getCurrentRole())
                .targetRole(profile.getTargetRole())
                .targetCompany(profile.getTargetCompany())
                .timeline(profile.getTimeline())
                .yearsOfExperience(profile.getYearsOfExperience())
                .status(profile.getStatus())
                .resumeUploaded(resumeUploaded)
                .createdAt(profile.getCreatedAt())
                .updatedAt(profile.getUpdatedAt())
                .build();
    }

    private ResumeUploadResponse toResumeResponse(Resume resume) {
        return ResumeUploadResponse.builder()
                .id(resume.getId())
                .originalFilename(resume.getOriginalFilename())
                .fileSizeBytes(resume.getFileSizeBytes())
                .uploadedAt(resume.getUploadedAt())
                .build();
    }
}
