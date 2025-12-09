package com.flash.mastery.service.impl;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.dto.request.StudySessionCreateRequest;
import com.flash.mastery.dto.request.StudySessionUpdateRequest;
import com.flash.mastery.dto.response.StudySessionResponse;
import com.flash.mastery.entity.Flashcard;
import com.flash.mastery.entity.StudySession;
import com.flash.mastery.entity.enums.StudyMode;
import com.flash.mastery.entity.enums.StudySessionStatus;
import com.flash.mastery.mapper.StudySessionMapper;
import com.flash.mastery.repository.DeckRepository;
import com.flash.mastery.repository.FlashcardRepository;
import com.flash.mastery.repository.StudySessionRepository;
import com.flash.mastery.service.BaseService;
import com.flash.mastery.service.StudySessionService;

@Service
@Transactional
public class StudySessionServiceImpl extends BaseService implements StudySessionService {

    private final StudySessionRepository studySessionRepository;
    private final DeckRepository deckRepository;
    private final FlashcardRepository flashcardRepository;
    private final StudySessionMapper studySessionMapper;

    public StudySessionServiceImpl(
            StudySessionRepository studySessionRepository,
            DeckRepository deckRepository,
            FlashcardRepository flashcardRepository,
            StudySessionMapper studySessionMapper,
            MessageSource messageSource) {
        super(messageSource);
        this.studySessionRepository = studySessionRepository;
        this.deckRepository = deckRepository;
        this.flashcardRepository = flashcardRepository;
        this.studySessionMapper = studySessionMapper;
    }

    @Override
    public StudySessionResponse startSession(StudySessionCreateRequest request) {
        final var deck = this.deckRepository.findById(request.getDeckId());
        if (deck == null) {
            throw new com.flash.mastery.exception.NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_DECK));
        }

        // Use provided flashcard IDs if available (for custom selection)
        if ((request.getFlashcardIds() != null) && !request.getFlashcardIds().isEmpty()) {
            final var flashcardIds = request.getFlashcardIds();
            return createSession(deck, flashcardIds);
        }

        // Get all flashcards from deck (no pagination)
        final var flashcards = this.flashcardRepository.searchByDeckId(request.getDeckId(), null, null);
        if (flashcards.isEmpty()) {
            throw new IllegalArgumentException(msg(MessageKeys.ERROR_NO_FLASHCARDS_AVAILABLE));
        }

        final var allFlashcardIds = flashcards.stream()
                .map(Flashcard::getId).toList();

        // Get completed sessions (SUCCESS status) for this deck to find already studied
        // flashcards
        final var completedSessions = this.studySessionRepository
                .findByDeckIdAndStatus(request.getDeckId(), StudySessionStatus.SUCCESS);

        // Load progressData for all completed sessions and collect flashcard IDs that have
        // completed ALL study modes (OVERVIEW, MATCHING, GUESS, RECALL, FILL_IN_BLANK)
        final var studiedFlashcardIds = completedSessions.stream()
                .flatMap(session -> {
                    // Load progressData for this session
                    loadProgressData(session);
                    // Check each flashcard in this session
                    return session.getFlashcardIds().stream()
                            .filter(flashcardId -> {
                                final var progressData = session.getProgressData().get(flashcardId);
                                // A flashcard is considered fully studied only if it has completed
                                // all 5 study modes
                                return progressData != null && isFullyStudied(progressData);
                            });
                })
                .collect(Collectors.toSet());

        // Filter out already studied flashcards - only get unstudied ones
        final var unstudiedFlashcardIds = allFlashcardIds.stream()
                .filter(id -> !studiedFlashcardIds.contains(id))
                .collect(Collectors.toList());

        if (unstudiedFlashcardIds.isEmpty()) {
            throw new IllegalArgumentException(msg(MessageKeys.ERROR_ALL_FLASHCARDS_STUDIED));
        }

        // Shuffle to randomize order
        Collections.shuffle(unstudiedFlashcardIds);

        // Select flashcards based on batch size for this session
        final var flashcardIds = unstudiedFlashcardIds.stream()
                .limit(Math.min(NumberConstants.STUDY_SESSION_BATCH_SIZE, unstudiedFlashcardIds.size()))
                .toList();

        return createSession(deck, flashcardIds);
    }

    private StudySessionResponse createSession(com.flash.mastery.entity.Deck deck, List<UUID> flashcardIds) {
        final var session = StudySession.builder()
                .deckId(deck.getId())
                .flashcardIds(flashcardIds)
                .currentMode(StudyMode.OVERVIEW)
                .currentBatchIndex(0)
                .status(StudySessionStatus.IN_PROGRESS)
                .build();

        // Initialize entity and insert
        session.onCreate();
        this.studySessionRepository.insert(session);

        // Insert flashcard IDs into junction table
        if (!flashcardIds.isEmpty()) {
            this.studySessionRepository.insertFlashcardIds(session.getId(), flashcardIds);
        }

        return this.studySessionMapper.toResponse(session);
    }

    @Override
    @Transactional(readOnly = true)
    public StudySessionResponse getSession(UUID sessionId) {
        final var session = this.studySessionRepository.findById(sessionId);
        if (session == null) {
            throw new com.flash.mastery.exception.NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_SESSION));
        }
        // Load progressData from database
        loadProgressData(session);
        return this.studySessionMapper.toResponse(session);
    }

    @Override
    public StudySessionResponse updateSession(UUID sessionId, StudySessionUpdateRequest request) {
        final var session = this.studySessionRepository.findById(sessionId);
        if (session == null) {
            throw new com.flash.mastery.exception.NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_SESSION));
        }

        // Load progressData from database before checking/updating
        loadProgressData(session);

        if (request.getCurrentMode() != null) {
            session.setCurrentMode(request.getCurrentMode());
        }
        if (request.getCurrentBatchIndex() != null) {
            session.setCurrentBatchIndex(request.getCurrentBatchIndex());
        }

        // Handle progress data updates
        if (request.getProgressData() != null) {
            for (var entry : request.getProgressData().entrySet()) {
                final var flashcardId = entry.getKey();
                final var progressData = entry.getValue();

                // Update or insert progress data based on whether it exists in database
                if (session.getProgressData().containsKey(flashcardId)) {
                    this.studySessionRepository.updateProgressData(sessionId, flashcardId, progressData);
                } else {
                    this.studySessionRepository.insertProgressData(sessionId, flashcardId, progressData);
                }

                // Update in-memory map
                session.getProgressData().put(flashcardId, progressData);
            }
        }

        session.onUpdate();
        this.studySessionRepository.update(session);

        return this.studySessionMapper.toResponse(session);
    }

    @Override
    public void completeSession(UUID sessionId) {
        final var session = this.studySessionRepository.findById(sessionId);
        if (session == null) {
            throw new com.flash.mastery.exception.NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_SESSION));
        }

        session.setCompletedAt(LocalDateTime.now());
        session.setStatus(StudySessionStatus.SUCCESS);
        session.onUpdate();
        this.studySessionRepository.update(session);
    }

    @Override
    public void cancelSession(UUID sessionId) {
        final var session = this.studySessionRepository.findById(sessionId);
        if (session == null) {
            throw new com.flash.mastery.exception.NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_SESSION));
        }

        session.setStatus(StudySessionStatus.CANCEL);
        session.onUpdate();
        this.studySessionRepository.update(session);
    }

    /**
     * Load progressData from database into the session entity.
     * MyBatis doesn't automatically populate Map fields, so we need to load it
     * manually.
     */
    private void loadProgressData(StudySession session) {
        final var progressDataList = this.studySessionRepository.findProgressDataBySessionId(session.getId());
        session.getProgressData().clear();
        for (final var row : progressDataList) {
            final var flashcardId = (UUID) row.get("flashcard_id");
            final var progressData = (String) row.get("progress_data");
            if (flashcardId != null && progressData != null) {
                session.getProgressData().put(flashcardId, progressData);
            }
        }
    }

    /**
     * Check if a flashcard has been fully studied (completed all 5 study modes).
     * Progress data format: "OVERVIEW:true,MATCHING:true,GUESS:true,RECALL:true,FILL_IN_BLANK:true"
     *
     * @param progressData The progress data string for the flashcard
     * @return true if all 5 modes are completed, false otherwise
     */
    private boolean isFullyStudied(String progressData) {
        if (progressData == null || progressData.isEmpty()) {
            return false;
        }

        // Check that all 5 study modes are present and completed (true)
        final var requiredModes = new String[] { "OVERVIEW:true", "MATCHING:true", "GUESS:true",
                "RECALL:true", "FILL_IN_BLANK:true" };

        for (final var mode : requiredModes) {
            if (!progressData.contains(mode)) {
                return false;
            }
        }

        return true;
    }
}
