package com.flash.mastery.entity;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
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
    private List<StudySessionProgress> progress = new ArrayList<>();

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
     * All flashcards in current batch must have completed the current mode.
     */
    public boolean isCurrentBatchComplete() {
        final List<UUID> batch = getCurrentBatch();
        return batch.stream()
                .allMatch(flashcardId -> progress.stream()
                        .anyMatch(p -> p.getFlashcardId().equals(flashcardId)
                                && p.getMode().equals(currentMode)
                                && Boolean.TRUE.equals(p.getCompleted())));
    }

    /**
     * Get progress for a specific flashcard and mode.
     *
     * @param flashcardId the flashcard ID
     * @param mode        the study mode
     * @return Optional containing the progress if found
     */
    public Optional<StudySessionProgress> getProgressForFlashcard(final UUID flashcardId, final StudyMode mode) {
        return progress.stream()
                .filter(p -> p.getFlashcardId().equals(flashcardId) && p.getMode().equals(mode))
                .findFirst();
    }

    /**
     * Add or update progress entry.
     * If progress already exists for the flashcard and mode, it will be replaced.
     *
     * @param newProgress the progress to add or update
     */
    public void addOrUpdateProgress(final StudySessionProgress newProgress) {
        final Optional<StudySessionProgress> existing = getProgressForFlashcard(
                newProgress.getFlashcardId(),
                newProgress.getMode());
        if (existing.isPresent()) {
            progress.remove(existing.get());
        }
        progress.add(newProgress);
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
