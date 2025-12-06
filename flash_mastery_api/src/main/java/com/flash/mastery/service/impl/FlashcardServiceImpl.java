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
import com.flash.mastery.service.FlashcardService;
import java.util.List;
import java.util.UUID;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class FlashcardServiceImpl implements FlashcardService {

  private final FlashcardRepository flashcardRepository;
  private final DeckRepository deckRepository;
  private final FlashcardMapper flashcardMapper;
  private final MessageSource messageSource;

  @Override
  @Transactional(readOnly = true)
  public List<FlashcardResponse> getByDeck(UUID deckId) {
    List<Flashcard> cards = flashcardRepository.findByDeckId(deckId);
    return cards.stream().map(flashcardMapper::toResponse).toList();
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
    if (request.getType() != null) {
      card.setType(request.getType());
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

  private String msg(String key) {
    return messageSource.getMessage(key, null, LocaleContextHolder.getLocale());
  }
}
