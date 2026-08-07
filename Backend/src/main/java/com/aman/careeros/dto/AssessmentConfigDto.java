package com.aman.careeros.dto;

import com.aman.careeros.entity.AssessmentTopic;
import com.aman.careeros.entity.ExperienceLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * AssessmentConfigDto - The assessment configuration section of the intro response.
 * Topics are derived from targetRole only (Phase-1); difficultyLevel from yearsOfExperience.
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AssessmentConfigDto {
    private List<AssessmentTopic> topics;
    private int questionCount;
    private int estimatedMinutes;
    private ExperienceLevel difficultyLevel;
}
