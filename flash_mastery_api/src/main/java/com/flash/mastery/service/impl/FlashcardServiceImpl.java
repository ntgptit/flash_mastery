package com.flash.mastery.service.impl;

import java.util.List;
import java.util.UUID;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.dto.request.FlashcardCreateRequest;
import com.flash.mastery.dto.request.FlashcardUpdateRequest;
import com.flash.mastery.dto.response.FlashcardResponse;
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
        // Calculate offset and limit for pagination (null if no pagination)
        final Integer offset;
        final Integer limit;

        if (page != null && size != null) {
            final var safePage = Math.max(page, NumberConstants.ZERO);
            final var safeSize = Math.max(size, NumberConstants.ONE);
            offset = safePage * safeSize;
            limit = safeSize;
        } else {
            offset = null;
            limit = null;
        }

        // Use dynamic SQL to handle both paginated and non-paginated queries
        final var flashcards = this.flashcardRepository.searchByDeckId(deckId, offset, limit);
        return flashcards.stream().map(this.flashcardMapper::toResponse).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public FlashcardResponse getById(UUID id) {
        final var card = this.flashcardRepository.findById(id);
        if (card == null) {
            throw new com.flash.mastery.exception.NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FLASHCARD));
        }
        return this.flashcardMapper.toResponse(card);
    }

    @Override
    public FlashcardResponse create(FlashcardCreateRequest request) {
        if (request.getDeckId() == null) {
            throw new IllegalArgumentException(msg(MessageKeys.ERROR_DECK_ID_NULL));
        }
        final var deck = this.deckRepository.findById(request.getDeckId());
        if (deck == null) {
            throw new com.flash.mastery.exception.NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_DECK));
        }

        final var deckType = deck.getType() != null ? deck.getType() : request.getType();
        final var requestedType = request.getType() != null ? request.getType() : deckType;
        if ((deckType != null) && (requestedType != null) && (deckType != requestedType)) {
            throw new IllegalArgumentException(msg(MessageKeys.ERROR_FLASHCARD_TYPE_MISMATCH));
        }
        if (requestedType != null) {
            request.setType(requestedType);
        }

        final var card = this.flashcardMapper.fromCreate(request, deck);
        card.setDeckId(request.getDeckId());
        card.onCreate();
        this.flashcardRepository.insert(card);

        // Update deck card count
        deck.setCardCount(incrementCount(deck.getCardCount(), NumberConstants.ONE));
        deck.onUpdate();
        this.deckRepository.update(deck);

        return this.flashcardMapper.toResponse(card);
    }

    @Override
    public FlashcardResponse update(UUID id, FlashcardUpdateRequest request) {
        final var card = this.flashcardRepository.findById(id);
        if (card == null) {
            throw new com.flash.mastery.exception.NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FLASHCARD));
        }

        this.flashcardMapper.update(card, request);

        // Load deck to validate type
        final var deck = card.getDeckId() != null ? this.deckRepository.findById(card.getDeckId()) : null;
        final var deckType = deck != null ? deck.getType() : null;
        final var targetType = request.getType() != null ? request.getType() : card.getType();

        if ((deckType != null) && (targetType != null) && (deckType != targetType)) {
            throw new IllegalArgumentException(msg(MessageKeys.ERROR_FLASHCARD_TYPE_MISMATCH));
        }
        if (targetType != null) {
            card.setType(targetType);
        }
        if ((targetType == null) && (deckType != null)) {
            card.setType(deckType);
        }

        card.onUpdate();
        this.flashcardRepository.update(card);

        return this.flashcardMapper.toResponse(card);
    }

    @Override
    public void delete(UUID id) {
        final var card = this.flashcardRepository.findById(id);
        if (card == null) {
            throw new com.flash.mastery.exception.NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FLASHCARD));
        }

        this.flashcardRepository.deleteById(id);

        // Update deck card count
        if (card.getDeckId() != null) {
            final var deck = this.deckRepository.findById(card.getDeckId());
            if ((deck != null) && (deck.getCardCount() > NumberConstants.ZERO)) {
                deck.setCardCount(decrementCount(deck.getCardCount(), NumberConstants.ONE));
                deck.onUpdate();
                this.deckRepository.update(deck);
            }
        }
    }

}
