package com.flash.mastery.service.impl;

import java.util.List;
import java.util.UUID;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.flash.mastery.constant.ErrorCodes;
import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.dto.criteria.FlashcardSearchCriteria;
import com.flash.mastery.dto.request.FlashcardCreateRequest;
import com.flash.mastery.dto.request.FlashcardUpdateRequest;
import com.flash.mastery.dto.response.FlashcardResponse;
import com.flash.mastery.exception.BadRequestException;
import com.flash.mastery.mapper.FlashcardMapper;
import com.flash.mastery.repository.DeckRepository;
import com.flash.mastery.repository.FlashcardRepository;
import com.flash.mastery.service.BaseService;
import com.flash.mastery.service.FlashcardService;

@Service
@Transactional
public class FlashcardServiceImpl extends BaseService implements FlashcardService {

    private final FlashcardRepository flashcardRepository;
    private final DeckRepository deckRepository;
    private final FlashcardMapper flashcardMapper;

    public FlashcardServiceImpl(
            FlashcardRepository flashcardRepository,
            DeckRepository deckRepository,
            FlashcardMapper flashcardMapper,
            MessageSource messageSource) {
        super(messageSource);
        this.flashcardRepository = flashcardRepository;
        this.deckRepository = deckRepository;
        this.flashcardMapper = flashcardMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public List<FlashcardResponse> getByDeck(UUID deckId, Integer page, Integer size) {
        final var criteria = FlashcardSearchCriteria.builder()
                .deckId(deckId)
                .page(page)
                .size(size)
                .build();

        // Normalize pagination parameters
        final var normalizedCriteria = normalizePagination(criteria);
        final var flashcards = this.flashcardRepository.findByCriteria(normalizedCriteria);
        return flashcards.stream().map(this.flashcardMapper::toResponse).toList();
    }

    /**
     * Normalize pagination parameters in criteria.
     */
    private FlashcardSearchCriteria normalizePagination(FlashcardSearchCriteria criteria) {
        if (!criteria.hasPagination()) {
            return criteria;
        }

        final var safePage = Math.max(criteria.getPage(), NumberConstants.ZERO);
        final var safeSize = Math.max(criteria.getSize(), NumberConstants.ONE);
        return FlashcardSearchCriteria.builder()
                .deckId(criteria.getDeckId())
                .page(safePage)
                .size(safeSize)
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public FlashcardResponse getById(UUID id) {
        final var card = findByIdOrThrow(
                this.flashcardRepository.findById(id),
                ErrorCodes.FLASHCARD_NOT_FOUND, MessageKeys.ERROR_FLASHCARD_NOT_FOUND);
        return this.flashcardMapper.toResponse(card);
    }

    @Override
    public FlashcardResponse create(FlashcardCreateRequest request) {
        if (request.getDeckId() == null) {
            throw new BadRequestException(
                    ErrorCodes.DECK_ID_REQUIRED, MessageKeys.ERROR_DECK_ID_REQUIRED);
        }
        final var deck = findByIdOrThrow(
                this.deckRepository.findById(request.getDeckId()),
                ErrorCodes.DECK_NOT_FOUND, MessageKeys.ERROR_DECK_NOT_FOUND);
        final var deckType = deck.getType() != null ? deck.getType() : request.getType();
        final var requestedType = request.getType() != null ? request.getType() : deckType;
        if ((deckType != null) && (requestedType != null) && (deckType != requestedType)) {
            throw new BadRequestException(
                    ErrorCodes.FLASHCARD_TYPE_MISMATCH, MessageKeys.ERROR_FLASHCARD_TYPE_MISMATCH);
        }
        if (requestedType != null) {
            request.setType(requestedType);
        }
        final var card = this.flashcardMapper.fromCreate(request, deck);
        final var saved = this.flashcardRepository.save(card);
        deck.setCardCount(incrementCount(deck.getCardCount(), NumberConstants.ONE));
        this.deckRepository.save(deck);
        return this.flashcardMapper.toResponse(saved);
    }

    @Override
    public FlashcardResponse update(UUID id, FlashcardUpdateRequest request) {
        final var card = findByIdOrThrow(
                this.flashcardRepository.findById(id),
                ErrorCodes.FLASHCARD_NOT_FOUND, MessageKeys.ERROR_FLASHCARD_NOT_FOUND);
        this.flashcardMapper.update(card, request);
        final var deck = card.getDeck();
        final var deckType = deck != null ? deck.getType() : null;
        final var targetType = request.getType() != null ? request.getType() : card.getType();
        if ((deckType != null) && (targetType != null) && (deckType != targetType)) {
            throw new BadRequestException(
                    ErrorCodes.FLASHCARD_TYPE_MISMATCH, MessageKeys.ERROR_FLASHCARD_TYPE_MISMATCH);
        }
        if (targetType != null) {
            card.setType(targetType);
        }
        if ((targetType == null) && (deckType != null)) {
            card.setType(deckType);
        }
        final var saved = this.flashcardRepository.save(card);
        return this.flashcardMapper.toResponse(saved);
    }

    @Override
    public void delete(UUID id) {
        final var card = findByIdOrThrow(
                this.flashcardRepository.findById(id),
                ErrorCodes.FLASHCARD_NOT_FOUND, MessageKeys.ERROR_FLASHCARD_NOT_FOUND);
        this.flashcardRepository.delete(card);
        final var deck = card.getDeck();
        if ((deck != null) && (deck.getCardCount() > NumberConstants.ZERO)) {
            deck.setCardCount(decrementCount(deck.getCardCount(), NumberConstants.ONE));
            this.deckRepository.save(deck);
        }
    }

}
