package com.aman.careeros.service;

import com.aman.careeros.config.AssessmentRoleConfig;
import com.aman.careeros.dto.AssessmentConfigDto;
import com.aman.careeros.dto.AssessmentIntroResponse;
import com.aman.careeros.entity.ExperienceLevel;
import com.aman.careeros.entity.OnboardingProfile;
import com.aman.careeros.entity.Resume;
import com.aman.careeros.entity.User;
import com.aman.careeros.exception.ResourceNotFoundException;
import com.aman.careeros.repository.OnboardingProfileRepository;
import com.aman.careeros.repository.ResumeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * AssessmentService - Builds the assessment introduction response.
 *
 * Aggregates profile data, resume analysis results stored during upload,
 * and the role-based assessment configuration. No AI calls at request time.
 */
@Service
@RequiredArgsConstructor
public class AssessmentService {

    private final OnboardingProfileRepository profileRepository;
    private final ResumeRepository resumeRepository;
    private final AssessmentRoleConfig roleConfig;

    public AssessmentIntroResponse getIntro(User user) {
        OnboardingProfile profile = profileRepository.findByUserId(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Onboarding profile not found"));

        Resume resume = resumeRepository.findTopByUserIdOrderByUploadedAtDesc(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Resume not found"));

        AssessmentRoleConfig.TopicConfig topicConfig = roleConfig.getConfig(profile.getTargetRole());
        ExperienceLevel difficulty = ExperienceLevel.fromYearsOfExperience(profile.getYearsOfExperience());

        return AssessmentIntroResponse.builder()
                .userName(user.getName())
                .currentRole(profile.getCurrentRole())
                .targetRole(profile.getTargetRole())
                .targetCompany(profile.getTargetCompany())
                .yearsOfExperience(profile.getYearsOfExperience())
                .fileName(resume.getOriginalFilename())
                .detectedSkills(resume.getDetectedSkills())
                .experienceLevel(resume.getExperienceLevel())
                .assessmentConfig(AssessmentConfigDto.builder()
                        .topics(topicConfig.topics())
                        .questionCount(topicConfig.questionCount())
                        .estimatedMinutes(topicConfig.estimatedMinutes())
                        .difficultyLevel(difficulty)
                        .build())
                .build();
    }
}
