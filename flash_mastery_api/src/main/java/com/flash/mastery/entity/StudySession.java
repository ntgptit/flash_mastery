package com.flash.mastery.entity;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.entity.enums.StudyMode;
import com.flash.mastery.entity.enums.StudySessionStatus;

import jakarta.persistence.CascadeType;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "study_sessions")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudySession extends BaseAuditEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "deck_id", nullable = false)
    @ToString.Exclude
    private Deck deck;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "study_session_flashcard_ids", joinColumns = @JoinColumn(name = "session_id"))
    @Column(name = "flashcard_id")
    @Default
    private List<UUID> flashcardIds = new ArrayList<>();

    @Enumerated(EnumType.STRING)
    @Column(name = "current_mode", nullable = false)
    @Default
    private StudyMode currentMode = StudyMode.OVERVIEW;

    @Column(name = "current_batch_index", nullable = false)
    @Default
    private Integer currentBatchIndex = 0;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    @Default
    private StudySessionStatus status = StudySessionStatus.IN_PROGRESS;

    @OneToMany(mappedBy = "session", cascade = CascadeType.ALL, orphanRemoval = true)
    @Default
    @ToString.Exclude
    private List<StudySessionProgress> progressRecords = new ArrayList<>();

    @Column(name = "completed_at")
    private java.time.LocalDateTime completedAt;

    /**
     * Ensure status is never null before persisting or updating.
     */
    @PrePersist
    @PreUpdate
    private void ensureStatus() {
        if (this.status == null) {
            this.status = StudySessionStatus.IN_PROGRESS;
        }
    }

    /**
     * Get flashcards for current batch.
     */
    public List<UUID> getCurrentBatch() {
        final var batchSize = NumberConstants.STUDY_SESSION_BATCH_SIZE;
        final var start = this.currentBatchIndex * batchSize;
        final var end = Math.min(start + batchSize, this.flashcardIds.size());
        if (start >= this.flashcardIds.size()) {
            return new ArrayList<>();
        }
        return this.flashcardIds.subList(start, end);
    }

    /**
     * Check if current batch is complete.
     */
    public boolean isCurrentBatchComplete() {
        final var batch = getCurrentBatch();
        return batch.stream()
                .allMatch(id -> this.progressRecords.stream()
                        .filter(p -> p.getFlashcard().getId().equals(id))
                        .findFirst()
                        .map(p -> p.isModeCompleted(this.currentMode))
                        .orElse(false));
    }

    /**
     * Get next mode in sequence.
     */
    public StudyMode getNextMode() {
        return switch (this.currentMode) {
        case OVERVIEW -> StudyMode.MATCHING;
        case MATCHING -> StudyMode.GUESS;
        case GUESS -> StudyMode.RECALL;
        case RECALL -> StudyMode.FILL_IN_BLANK;
        case FILL_IN_BLANK -> null; // All modes completed
        default -> null;
        };
    }
}
