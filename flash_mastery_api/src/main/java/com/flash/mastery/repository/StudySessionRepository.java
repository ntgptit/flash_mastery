package com.flash.mastery.repository;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.flash.mastery.constant.RepositoryConstants;
import com.flash.mastery.entity.StudySession;
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

    void insertProgressData(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId,
            @Param(RepositoryConstants.PARAM_FLASHCARD_ID) UUID flashcardId,
            @Param(RepositoryConstants.PARAM_PROGRESS_DATA) String progressData);

    void updateProgressData(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId,
            @Param(RepositoryConstants.PARAM_FLASHCARD_ID) UUID flashcardId,
            @Param(RepositoryConstants.PARAM_PROGRESS_DATA) String progressData);

    void deleteProgressDataBySessionId(@Param(RepositoryConstants.PARAM_SESSION_ID) UUID sessionId);
}
