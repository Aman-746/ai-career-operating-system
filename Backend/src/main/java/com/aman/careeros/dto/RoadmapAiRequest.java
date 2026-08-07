package com.aman.careeros.dto;

import com.aman.careeros.entity.AssessmentSession;

import java.util.List;

public record RoadmapAiRequest(
        String targetRole,
        int totalWeeks,
        String experienceLevel,
        int yearsOfExperience,
        List<String> resumeSkills,
        List<AssessmentSession.TopicScore> topicScores,
        List<GapSummary> gaps,
        List<StrengthSummary> strengths) {

    public record GapSummary(String area, String severity) {
    }

    public record StrengthSummary(String area, String evidence) {
    }
}
