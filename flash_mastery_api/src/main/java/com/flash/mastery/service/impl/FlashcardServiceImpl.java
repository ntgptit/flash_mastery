package com.flash.mastery.service.impl;

import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.dto.request.FlashcardCreateRequest;
import com.flash.mastery.dto.request.FlashcardUpdateRequest;
import com.flash.mastery.dto.response.FlashcardResponse;
import com.flash.mastery.entity.Deck;
import com.flash.mastery.entity.Flashcard;
import com.flash.mastery.exception.NotFoundException;
import com.flash.mastery.mapper.FlashcardMapper;
import com.flash.mastery.repository.DeckRepository;
import com.flash.mastery.repository.FlashcardRepository;
import com.flash.mastery.service.BaseService;
import com.flash.mastery.service.FlashcardService;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    if ((page == null) || (size == null) || (size <= 0)) {
      List<Flashcard> cards = flashcardRepository.findByDeckId(deckId);
      return cards.stream().map(flashcardMapper::toResponse).toList();
    }
    final int safePage = Math.max(page, NumberConstants.ZERO);
    final int safeSize = Math.max(size, NumberConstants.ONE);
    final Pageable pageable = PageRequest.of(safePage, safeSize, Sort.by(Sort.Direction.DESC, "createdAt"));
    return flashcardRepository.findByDeckId(deckId, pageable)
        .stream()
        .map(flashcardMapper::toResponse)
        .toList();
  }

  @Override
  @Transactional(readOnly = true)
  public FlashcardResponse getById(UUID id) {
    Flashcard card =
        flashcardRepository.findById(id)
            .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FLASHCARD)));
    return flashcardMapper.toResponse(card);
  }

  @Override
  public FlashcardResponse create(FlashcardCreateRequest request) {
    if (request.getDeckId() == null) {
      throw new IllegalArgumentException("Deck ID must not be null when creating flashcard");
    }
    Deck deck = deckRepository.findById(request.getDeckId())
        .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_DECK)));
    var deckType = deck.getType() != null ? deck.getType() : request.getType();
    var requestedType = request.getType() != null ? request.getType() : deckType;
    if (deckType != null && requestedType != null && deckType != requestedType) {
      throw new IllegalArgumentException("Flashcard type must match deck type");
    }
    if (requestedType != null) {
      request.setType(requestedType);
    }
    Flashcard card = flashcardMapper.fromCreate(request, deck);
    Flashcard saved = flashcardRepository.save(card);
    deck.setCardCount(deck.getCardCount() + NumberConstants.ONE);
    deckRepository.save(deck);
    return flashcardMapper.toResponse(saved);
  }

  @Override
  public FlashcardResponse update(UUID id, FlashcardUpdateRequest request) {
    Flashcard card =
        flashcardRepository.findById(id)
            .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FLASHCARD)));
    flashcardMapper.update(card, request);
    var deck = card.getDeck();
    var deckType = deck != null ? deck.getType() : null;
    var targetType = request.getType() != null ? request.getType() : card.getType();
    if (deckType != null && targetType != null && deckType != targetType) {
      throw new IllegalArgumentException("Flashcard type must match deck type");
    }
    if (targetType != null) {
      card.setType(targetType);
    } else if (deckType != null) {
      card.setType(deckType);
    }
    Flashcard saved = flashcardRepository.save(card);
    return flashcardMapper.toResponse(saved);
  }

  @Override
  public void delete(UUID id) {
    Flashcard card =
        flashcardRepository.findById(id)
            .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FLASHCARD)));
    flashcardRepository.delete(card);
    Deck deck = card.getDeck();
    if (deck != null && deck.getCardCount() > NumberConstants.ZERO) {
      deck.setCardCount(deck.getCardCount() - NumberConstants.ONE);
      deckRepository.save(deck);
    }
  }

}
