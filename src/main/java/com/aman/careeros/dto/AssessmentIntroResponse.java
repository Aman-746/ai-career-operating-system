package com.aman.careeros.dto;

import com.aman.careeros.entity.ExperienceLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * AssessmentIntroResponse - The full response for GET /api/assessment/intro.
 * Aggregates profile data, resume analysis results, and the assessment configuration
 * derived from the user's target role.
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AssessmentIntroResponse {
    private String userName;
    private String currentRole;
    private String targetRole;
    private String targetCompany;
    private int yearsOfExperience;
    private String fileName;
    private List<String> detectedSkills;
    private ExperienceLevel experienceLevel;
    private AssessmentConfigDto assessmentConfig;
}
