package com.flash.mastery.dto.response;

import java.time.LocalDateTime;
import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.flash.mastery.entity.enums.StudyMode;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO for study session progress response.
 * Contains progress data for a single flashcard in a specific study mode.
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudySessionProgressResponse {

    @JsonProperty("flashcardId")
    private UUID flashcardId;

    @JsonProperty("mode")
    private StudyMode mode;

    @JsonProperty("completed")
    private Boolean completed;

    @JsonProperty("completedAt")
    private LocalDateTime completedAt;

    @JsonProperty("correctAnswers")
    private Integer correctAnswers;

    @JsonProperty("totalAttempts")
    private Integer totalAttempts;

    @JsonProperty("lastStudiedAt")
    private LocalDateTime lastStudiedAt;

    /**
     * Calculated accuracy percentage (0.0 to 1.0).
     * Computed from correctAnswers / totalAttempts.
     */
    @JsonProperty("accuracy")
    private Double accuracy;
}
