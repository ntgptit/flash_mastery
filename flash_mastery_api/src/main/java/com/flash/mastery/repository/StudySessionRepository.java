package com.flash.mastery.repository;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.flash.mastery.constant.RepositoryConstants;
import com.flash.mastery.entity.StudySession;
import com.flash.mastery.entity.StudySessionProgress;
import com.flash.mastery.entity.enums.StudyMode;
import com.flash.mastery.entity.enums.StudySessionStatus;

@Mapper
public interface StudySessionRepository {

    StudySession findById(@Param(RepositoryConstants.PARAM_ID) UUID id);

    List<StudySession> findByDeckId(@Param(RepositoryConstants.PARAM_DECK_ID) UUID deckId);

    List<StudySession> findByDeckIdAndStatus(@Param(RepositoryConstants.PARAM_DECK_ID) UUID deckId,
            @Param(RepositoryConstants.PARAM_STATUS) StudySessionStatus status);

    void insert(StudySession studySession);

    void update(StudySession studySession);

    void deleteById(@Param(RepositoryConstants.PARAM_ID) UUID id);

    void insertFlashcardIds(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId,
            @Param(RepositoryConstants.PARAM_FLASHCARD_IDS) List<UUID> flashcardIds);

    void deleteFlashcardIdsBySessionId(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId);

    List<UUID> findFlashcardIdsBySessionId(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId);

    // ==================== PROGRESS OPERATIONS ====================

    /**
     * Insert a new progress entry.
     */
    void insertProgress(StudySessionProgress progress);

    /**
     * Update an existing progress entry.
     */
    void updateProgress(StudySessionProgress progress);

    /**
     * Delete a specific progress entry by composite key.
     */
    void deleteProgress(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId,
            @Param(RepositoryConstants.PARAM_FLASHCARD_ID) UUID flashcardId,
            @Param("mode") StudyMode mode);

    /**
     * Delete all progress entries for a session.
     */
    void deleteAllProgressBySessionId(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId);

    /**
     * Batch insert progress entries.
     */
    void insertProgressBatch(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId,
            @Param("progressList") List<StudySessionProgress> progressList);

    /**
     * Find all progress entries for a session.
     */
    List<StudySessionProgress> findProgressBySessionId(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId);

    /**
     * Find all progress entries for a specific flashcard in a session.
     */
    List<StudySessionProgress> findProgressBySessionIdAndFlashcardId(
            @Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId,
            @Param(RepositoryConstants.PARAM_FLASHCARD_ID) UUID flashcardId);

    /**
     * Find a specific progress entry by composite key.
     */
    StudySessionProgress findProgressByKey(
            @Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId,
            @Param(RepositoryConstants.PARAM_FLASHCARD_ID) UUID flashcardId,
            @Param("mode") StudyMode mode);

    /**
     * Count completed progress entries for a session and mode.
     */
    Integer countCompletedBySessionIdAndMode(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId,
            @Param("mode") StudyMode mode);

    /**
     * Find all incomplete progress entries for a session.
     */
    List<StudySessionProgress> findIncompleteProgressBySessionId(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId);
}
