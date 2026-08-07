package com.aman.careeros.dto;

import com.aman.careeros.entity.AssessmentSession;

import java.util.List;

public record GapAnalysisRequest(
        String targetRole,
        String experienceLevel,
        int yearsOfExperience,
        List<String> resumeSkills,
        List<String> roleExpectedTopics,
        List<AssessmentSession.TopicScore> topicScores,
        List<MissedQuestion> missedQuestions) {

    public record MissedQuestion(
            String topic,
            String topicDisplayName,
            String difficulty,
            String stem) {
    }
}
