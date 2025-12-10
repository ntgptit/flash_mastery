package com.flash.mastery.entity;

import java.time.LocalDateTime;
import java.util.EnumMap;
import java.util.Map;

import com.flash.mastery.entity.enums.StudyMode;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "study_session_progress", uniqueConstraints = {
        @UniqueConstraint(name = "uk_session_flashcard", columnNames = { "session_id", "flashcard_id" })
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudySessionProgress extends BaseAuditEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id", nullable = false)
    @ToString.Exclude
    private StudySession session;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "flashcard_id", nullable = false)
    @ToString.Exclude
    private Flashcard flashcard;

    @Column(name = "overview_completed", nullable = false)
    @Builder.Default
    private boolean overviewCompleted = false;

    @Column(name = "matching_completed", nullable = false)
    @Builder.Default
    private boolean matchingCompleted = false;

    @Column(name = "guess_completed", nullable = false)
    @Builder.Default
    private boolean guessCompleted = false;

    @Column(name = "recall_completed", nullable = false)
    @Builder.Default
    private boolean recallCompleted = false;

    @Column(name = "fill_in_blank_completed", nullable = false)
    @Builder.Default
    private boolean fillInBlankCompleted = false;

    @Column(name = "correct_answers", nullable = false)
    @Builder.Default
    private int correctAnswers = 0;

    @Column(name = "total_attempts", nullable = false)
    @Builder.Default
    private int totalAttempts = 0;

    @Column(name = "last_studied_at")
    private LocalDateTime lastStudiedAt;

    public void markModeCompleted(StudyMode mode) {
        switch (mode) {
        case OVERVIEW -> this.overviewCompleted = true;
        case MATCHING -> this.matchingCompleted = true;
        case GUESS -> this.guessCompleted = true;
        case RECALL -> this.recallCompleted = true;
        case FILL_IN_BLANK -> this.fillInBlankCompleted = true;
        }
        this.lastStudiedAt = LocalDateTime.now();
    }

    public boolean isModeCompleted(StudyMode mode) {
        return switch (mode) {
        case OVERVIEW -> this.overviewCompleted;
        case MATCHING -> this.matchingCompleted;
        case GUESS -> this.guessCompleted;
        case RECALL -> this.recallCompleted;
        case FILL_IN_BLANK -> this.fillInBlankCompleted;
        };
    }

    public Map<StudyMode, Boolean> getModeCompletionMap() {
        final Map<StudyMode, Boolean> map = new EnumMap<>(StudyMode.class);
        map.put(StudyMode.OVERVIEW, this.overviewCompleted);
        map.put(StudyMode.MATCHING, this.matchingCompleted);
        map.put(StudyMode.GUESS, this.guessCompleted);
        map.put(StudyMode.RECALL, this.recallCompleted);
        map.put(StudyMode.FILL_IN_BLANK, this.fillInBlankCompleted);
        return map;
    }

    public void updateAttempts(Integer correct, Integer total) {
        if (correct != null) {
            this.correctAnswers = correct;
        }
        if (total != null) {
            this.totalAttempts = total;
        }
        this.lastStudiedAt = LocalDateTime.now();
    }
}
