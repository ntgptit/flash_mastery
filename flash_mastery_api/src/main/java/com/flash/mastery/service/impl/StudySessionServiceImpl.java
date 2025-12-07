package com.flash.mastery.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.dto.request.StudySessionCreateRequest;
import com.flash.mastery.dto.request.StudySessionUpdateRequest;
import com.flash.mastery.dto.response.StudySessionResponse;
import com.flash.mastery.entity.Flashcard;
import com.flash.mastery.entity.StudySession;
import com.flash.mastery.entity.enums.StudyMode;
import com.flash.mastery.exception.NotFoundException;
import com.flash.mastery.mapper.StudySessionMapper;
import com.flash.mastery.repository.DeckRepository;
import com.flash.mastery.repository.FlashcardRepository;
import com.flash.mastery.repository.StudySessionRepository;
import com.flash.mastery.service.StudySessionService;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class StudySessionServiceImpl implements StudySessionService {

    private final StudySessionRepository studySessionRepository;
    private final DeckRepository deckRepository;
    private final FlashcardRepository flashcardRepository;
    private final StudySessionMapper studySessionMapper;
    private final MessageSource messageSource;

    @Override
    public StudySessionResponse startSession(StudySessionCreateRequest request) {
        final var deck = this.deckRepository.findById(request.getDeckId())
                .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_DECK)));

        List<UUID> flashcardIds;
        if ((request.getFlashcardIds() != null) && !request.getFlashcardIds().isEmpty()) {
            // Use provided flashcard IDs
            flashcardIds = request.getFlashcardIds();
        } else {
            // Get all flashcards from deck that haven't been studied
            final var flashcards = this.flashcardRepository.findByDeckId(request.getDeckId());
            flashcardIds = flashcards.stream()
                    .map(Flashcard::getId)
                    .collect(Collectors.toList());
        }

        if (flashcardIds.isEmpty()) {
            throw new IllegalArgumentException("No flashcards available for study");
        }

        final var session = StudySession.builder()
                .deck(deck)
                .flashcardIds(flashcardIds)
                .currentMode(StudyMode.OVERVIEW)
                .currentBatchIndex(0)
                .build();

        final var saved = this.studySessionRepository.save(session);
        return this.studySessionMapper.toResponse(saved);
    }

    @Override
    @Transactional(readOnly = true)
    public StudySessionResponse getSession(UUID sessionId) {
        final var session = this.studySessionRepository.findById(sessionId)
                .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_SESSION)));
        return this.studySessionMapper.toResponse(session);
    }

    @Override
    public StudySessionResponse updateSession(UUID sessionId, StudySessionUpdateRequest request) {
        final var session = this.studySessionRepository.findById(sessionId)
                .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_SESSION)));

        if (request.getCurrentMode() != null) {
            session.setCurrentMode(request.getCurrentMode());
        }
        if (request.getCurrentBatchIndex() != null) {
            session.setCurrentBatchIndex(request.getCurrentBatchIndex());
        }
        if (request.getProgressData() != null) {
            session.getProgressData().putAll(request.getProgressData());
        }

        final var saved = this.studySessionRepository.save(session);
        return this.studySessionMapper.toResponse(saved);
    }

    @Override
    public void completeSession(UUID sessionId) {
        final var session = this.studySessionRepository.findById(sessionId)
                .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_SESSION)));
        session.setCompletedAt(LocalDateTime.now());
        this.studySessionRepository.save(session);
    }

    private String msg(String key) {
        return this.messageSource.getMessage(key, null, LocaleContextHolder.getLocale());
    }
}
