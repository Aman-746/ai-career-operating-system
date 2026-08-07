package com.aman.careeros.repository;

import com.aman.careeros.entity.AssessmentTopic;
import com.aman.careeros.entity.Question;
import com.aman.careeros.entity.Question.Difficulty;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface QuestionRepository extends JpaRepository<Question, UUID> {

    /**
     * Random active questions for a given topic and difficulty.
     * ORDER BY random() is acceptable at MVP bank sizes (< 10k rows).
     */
    @Query("SELECT q FROM Question q WHERE q.topic = :topic AND q.difficulty = :difficulty AND q.active = true ORDER BY function('random')")
    List<Question> findActiveByTopicAndDifficulty(AssessmentTopic topic, Difficulty difficulty);

    /**
     * Count of active questions for a topic+difficulty — used by the startup sanity check.
     */
    int countByTopicAndDifficultyAndActiveTrue(AssessmentTopic topic, Difficulty difficulty);

    /**
     * Whether any active question exists for a topic — used by the startup sanity check.
     */
    boolean existsByTopicAndActiveTrue(AssessmentTopic topic);
}
