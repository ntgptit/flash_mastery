package com.flash.mastery.dto.request;

import java.time.LocalDateTime;
import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.flash.mastery.entity.enums.StudyMode;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * DTO for updating study session progress.
 * Represents progress for a single flashcard in a specific study mode.
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudySessionProgressUpdate {

    @NotNull(message = "Flashcard ID is required")
    @JsonProperty("flashcardId")
    private UUID flashcardId;

    @NotNull(message = "Study mode is required")
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
}
