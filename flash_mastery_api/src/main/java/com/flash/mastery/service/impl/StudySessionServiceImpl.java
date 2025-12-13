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
import com.flash.mastery.dto.request.StudySessionProgressUpdateRequest;
import com.flash.mastery.dto.request.StudySessionUpdateRequest;
import com.flash.mastery.dto.response.StudySessionResponse;
import com.flash.mastery.entity.Flashcard;
import com.flash.mastery.entity.StudySession;
import com.flash.mastery.entity.StudySessionProgress;
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
        final var deck = findByIdOrThrow(
                this.deckRepository.findById(request.getDeckId()),
                MessageKeys.ERROR_NOT_FOUND_DECK);

        // Use provided flashcard IDs if available (for custom selection)
        if ((request.getFlashcardIds() != null) && !request.getFlashcardIds().isEmpty()) {
            final var flashcardIds = request.getFlashcardIds();
            if (flashcardIds.isEmpty()) {
                throw new IllegalArgumentException("No flashcards available for study");
            }
            return createSession(deck, flashcardIds);
        }

        // Get all flashcards from deck
        final var flashcards = this.flashcardRepository.findByDeckId(request.getDeckId());
        if (flashcards.isEmpty()) {
            throw new IllegalArgumentException("No flashcards available for study");
        }

        final var allFlashcardIds = flashcards.stream()
                .map(Flashcard::getId).toList();

        // Get completed sessions (SUCCESS status) for this deck to find already studied
        // flashcards
        final var completedSessions = this.studySessionRepository
                .findByDeckIdAndStatus(request.getDeckId(), StudySessionStatus.SUCCESS);

        // Collect all flashcard IDs that have been studied (from completed sessions)
        final var studiedFlashcardIds = completedSessions.stream()
                .flatMap(session -> session.getFlashcardIds().stream())
                .collect(Collectors.toSet());

        // Filter out already studied flashcards - only get unstudied ones
        final var unstudiedFlashcardIds = allFlashcardIds.stream()
                .filter(id -> !studiedFlashcardIds.contains(id))
                .collect(Collectors.toList());

        if (unstudiedFlashcardIds.isEmpty()) {
            throw new IllegalArgumentException(
                    "All flashcards have been studied. Please add more flashcards to the deck.");
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
                .deck(deck)
                .flashcardIds(flashcardIds)
                .currentMode(StudyMode.OVERVIEW)
                .nextMode(StudySession.resolveNextMode(StudyMode.OVERVIEW))
                .currentBatchIndex(0)
                .status(StudySessionStatus.IN_PROGRESS)
                .build();

        final var saved = this.studySessionRepository.save(session);
        return this.studySessionMapper.toResponse(saved);
    }

    @Override
    @Transactional(readOnly = true)
    public StudySessionResponse getSession(UUID sessionId) {
        final var session = findByIdOrThrow(
                this.studySessionRepository.findById(sessionId),
                MessageKeys.ERROR_NOT_FOUND_SESSION);
        return this.studySessionMapper.toResponse(session);
    }

    @Override
    public StudySessionResponse updateSession(UUID sessionId, StudySessionUpdateRequest request) {
        final var session = findByIdOrThrow(
                this.studySessionRepository.findById(sessionId),
                MessageKeys.ERROR_NOT_FOUND_SESSION);

        if (request.getCurrentMode() != null) {
            session.setCurrentMode(request.getCurrentMode());
        }
        if (request.getNextMode() != null) {
            session.setNextMode(request.getNextMode());
        } else if (request.getCurrentMode() != null) {
            session.setNextMode(StudySession.resolveNextMode(request.getCurrentMode()));
        }
        if (request.getCurrentBatchIndex() != null) {
            session.setCurrentBatchIndex(request.getCurrentBatchIndex());
        }
        applyProgressUpdates(session, request.getProgressUpdates());

        final var saved = this.studySessionRepository.save(session);
        return this.studySessionMapper.toResponse(saved);
    }

    @Override
    public void completeSession(UUID sessionId) {
        final var session = findByIdOrThrow(
                this.studySessionRepository.findById(sessionId),
                MessageKeys.ERROR_NOT_FOUND_SESSION);
        session.setCompletedAt(LocalDateTime.now());
        session.setNextMode(null);
        session.setStatus(StudySessionStatus.SUCCESS);
        this.studySessionRepository.save(session);
    }

    @Override
    public void cancelSession(UUID sessionId) {
        final var session = findByIdOrThrow(
                this.studySessionRepository.findById(sessionId),
                MessageKeys.ERROR_NOT_FOUND_SESSION);
        session.setNextMode(null);
        session.setStatus(StudySessionStatus.CANCEL);
        this.studySessionRepository.save(session);
    }

    private void applyProgressUpdates(StudySession session, List<StudySessionProgressUpdateRequest> updates) {
        if (updates == null || updates.isEmpty()) {
            return;
        }

        for (StudySessionProgressUpdateRequest update : updates) {
            final var flashcard = findByIdOrThrow(
                    this.flashcardRepository.findById(update.getFlashcardId()),
                    MessageKeys.ERROR_NOT_FOUND_FLASHCARD);

            if (!session.getFlashcardIds().contains(flashcard.getId())) {
                throw new IllegalArgumentException("Flashcard is not part of this study session");
            }

            final var progress = findOrCreateProgress(session, flashcard);

            if (update.getCompletedModes() != null) {
                update.getCompletedModes().forEach(progress::markModeCompleted);
            }
            progress.updateAttempts(update.getCorrectAnswers(), update.getTotalAttempts());
        }
    }

    private StudySessionProgress findOrCreateProgress(StudySession session, Flashcard flashcard) {
        return session.getProgressRecords().stream()
                .filter(p -> p.getFlashcard().getId().equals(flashcard.getId()))
                .findFirst()
                .orElseGet(() -> {
                    final var newProgress = StudySessionProgress.builder()
                            .session(session)
                            .flashcard(flashcard)
                            .build();
                    session.getProgressRecords().add(newProgress);
                    return newProgress;
                });
    }
}
