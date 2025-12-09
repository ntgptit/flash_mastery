package com.flash.mastery.entity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.entity.enums.StudyMode;
import com.flash.mastery.entity.enums.StudySessionStatus;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudySession extends BaseAuditEntity {

    private UUID deckId;

    @ToString.Exclude
    private Deck deck;

    @Default
    private List<UUID> flashcardIds = new ArrayList<>();

    @Default
    private StudyMode currentMode = StudyMode.OVERVIEW;

    @Default
    private Integer currentBatchIndex = 0;

    @Default
    private StudySessionStatus status = StudySessionStatus.IN_PROGRESS;

    @Default
    private Map<UUID, String> progressData = new HashMap<>();

    /**
     * Ensure status is never null before persisting or updating.
     */
    public void ensureStatus() {
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
