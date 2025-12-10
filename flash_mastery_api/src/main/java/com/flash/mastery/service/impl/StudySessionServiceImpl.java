package com.flash.mastery.service.impl;

import java.util.Collections;
import java.util.List;
import java.util.UUID;

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
import com.flash.mastery.entity.StudySessionProgress;
import com.flash.mastery.entity.enums.StudyMode;
import com.flash.mastery.entity.enums.StudySessionStatus;
import com.flash.mastery.mapper.StudySessionMapper;
import com.flash.mastery.mapper.StudySessionProgressMapper;
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
    private final StudySessionProgressMapper studySessionProgressMapper;

    public StudySessionServiceImpl(
            StudySessionRepository studySessionRepository,
            DeckRepository deckRepository,
            FlashcardRepository flashcardRepository,
            StudySessionMapper studySessionMapper,
            StudySessionProgressMapper studySessionProgressMapper,
            MessageSource messageSource) {
        super(messageSource);
        this.studySessionRepository = studySessionRepository;
        this.deckRepository = deckRepository;
        this.flashcardRepository = flashcardRepository;
        this.studySessionMapper = studySessionMapper;
        this.studySessionProgressMapper = studySessionProgressMapper;
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

        // Shuffle to randomize order
        Collections.shuffle(allFlashcardIds);

        // Select flashcards based on batch size for this session
        final var flashcardIds = allFlashcardIds.stream()
                .limit(Math.min(NumberConstants.STUDY_SESSION_BATCH_SIZE, allFlashcardIds.size()))
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
        // Progress is auto-loaded by MyBatis via nested select
        return this.studySessionMapper.toResponse(session);
    }

    @Override
    public StudySessionResponse updateSession(UUID sessionId, StudySessionUpdateRequest request) {
        final var session = this.studySessionRepository.findById(sessionId);
        if (session == null) {
            throw new com.flash.mastery.exception.NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_SESSION));
        }

        // Update session fields
        if (request.getCurrentMode() != null) {
            session.setCurrentMode(request.getCurrentMode());
        }
        if (request.getCurrentBatchIndex() != null) {
            session.setCurrentBatchIndex(request.getCurrentBatchIndex());
        }

        // Handle progress updates (NEW LOGIC)
        if ((request.getProgressUpdates() != null) && !request.getProgressUpdates().isEmpty()) {
            for (final var progressUpdateDto : request.getProgressUpdates()) {
                // Check if progress already exists
                final var existing = this.studySessionRepository.findProgressByKey(
                        sessionId,
                        progressUpdateDto.getFlashcardId(),
                        progressUpdateDto.getMode());

                if (existing != null) {
                    // Update existing progress
                    existing.setCompleted(progressUpdateDto.getCompleted());
                    existing.setCompletedAt(progressUpdateDto.getCompletedAt());
                    existing.setCorrectAnswers(progressUpdateDto.getCorrectAnswers());
                    existing.setTotalAttempts(progressUpdateDto.getTotalAttempts());
                    existing.setLastStudiedAt(progressUpdateDto.getLastStudiedAt());
                    existing.onUpdate();
                    this.studySessionRepository.updateProgress(existing);

                    // Update in-memory list
                    session.addOrUpdateProgress(existing);
                } else {
                    // Convert DTO to entity using mapper
                    final var newProgress = this.studySessionProgressMapper.toEntity(progressUpdateDto);
                    newProgress.setSessionId(sessionId);
                    newProgress.onCreate();
                    this.studySessionRepository.insertProgress(newProgress);

                    // Update in-memory list
                    session.addOrUpdateProgress(newProgress);
                }
            }
        }

        session.onUpdate();
        this.studySessionRepository.update(session);

        return this.studySessionMapper.toResponse(session);
    }

}
