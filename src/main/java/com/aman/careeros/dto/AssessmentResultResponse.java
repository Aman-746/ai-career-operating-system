package com.aman.careeros.dto;

import com.aman.careeros.entity.AssessmentSession;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AssessmentResultResponse {
    private UUID sessionId;
    private String targetRole;
    private LocalDateTime completedAt;
    private int totalQuestions;
    private int totalCorrect;
    private int overallScore;
    private List<AssessmentSession.TopicScore> topicScores;
    private List<QuestionResultDto> questionResults;
}
