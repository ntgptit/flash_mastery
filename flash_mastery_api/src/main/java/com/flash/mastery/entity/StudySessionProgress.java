package com.flash.mastery.entity;

import java.time.LocalDateTime;
import java.util.UUID;

import com.flash.mastery.entity.enums.StudyMode;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Entity representing progress for a single flashcard in a specific study mode.
 * Tracks completion status, accuracy metrics, and timestamps.
 *
 * Composite key: (sessionId, flashcardId, mode)
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true, callSuper = false)
public class StudySessionProgress extends BaseAuditEntity {

    @EqualsAndHashCode.Include
    private UUID sessionId;

    @EqualsAndHashCode.Include
    private UUID flashcardId;

    @EqualsAndHashCode.Include
    private StudyMode mode;

    @Default
    private Boolean completed = false;

    private LocalDateTime completedAt;

    @Default
    private Integer correctAnswers = 0;

    @Default
    private Integer totalAttempts = 0;

    private LocalDateTime lastStudiedAt;

    /**
     * Mark this progress entry as completed.
     * Sets completed flag to true and records completion timestamp.
     */
    public void markCompleted() {
        this.completed = true;
        this.completedAt = LocalDateTime.now();
        this.lastStudiedAt = LocalDateTime.now();
    }

    /**
     * Record an attempt for this flashcard in this mode.
     *
     * @param isCorrect whether the attempt was correct
     */
    public void recordAttempt(final boolean isCorrect) {
        this.totalAttempts++;
        if (isCorrect) {
            this.correctAnswers++;
        }
        this.lastStudiedAt = LocalDateTime.now();
    }

    /**
     * Calculate accuracy as a percentage (0.0 to 1.0).
     *
     * @return accuracy ratio, or 0.0 if no attempts recorded
     */
    public double getAccuracy() {
        if ((this.totalAttempts == null) || (this.totalAttempts == 0)) {
            return 0.0;
        }
        return (double) this.correctAnswers / this.totalAttempts;
    }

    /**
     * Check if this progress has been started (has at least one attempt).
     *
     * @return true if at least one attempt recorded
     */
    public boolean isStarted() {
        return (this.totalAttempts != null) && (this.totalAttempts > 0);
    }
}
