package com.flash.mastery.entity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.entity.enums.StudyMode;
import com.flash.mastery.entity.enums.StudySessionStatus;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapKeyColumn;
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

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "study_session_progress", joinColumns = @JoinColumn(name = "session_id"))
    @MapKeyColumn(name = "flashcard_id")
    @Column(name = "progress_data")
    @Default
    private Map<UUID, String> progressData = new HashMap<>();

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
        final int batchSize = NumberConstants.STUDY_SESSION_BATCH_SIZE;
        final int start = currentBatchIndex * batchSize;
        final int end = Math.min(start + batchSize, flashcardIds.size());
        if (start >= flashcardIds.size()) {
            return new ArrayList<>();
        }
        return flashcardIds.subList(start, end);
    }

    /**
     * Check if current batch is complete.
     */
    public boolean isCurrentBatchComplete() {
        final List<UUID> batch = getCurrentBatch();
        return batch.stream()
                .allMatch(id -> {
                    String progress = progressData.get(id);
                    return progress != null && progress.contains("OVERVIEW:true");
                });
    }

    /**
     * Get next mode in sequence.
     */
    public StudyMode getNextMode() {
        switch (currentMode) {
            case OVERVIEW:
                return StudyMode.MATCHING;
            case MATCHING:
                return StudyMode.GUESS;
            case GUESS:
                return StudyMode.RECALL;
            case RECALL:
                return StudyMode.FILL_IN_BLANK;
            case FILL_IN_BLANK:
                return null; // All modes completed
            default:
                return null;
        }
    }
}
