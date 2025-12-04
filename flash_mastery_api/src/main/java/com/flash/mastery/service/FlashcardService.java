package com.flash.mastery.service;

import com.flash.mastery.dto.request.FlashcardCreateRequest;
import com.flash.mastery.dto.request.FlashcardUpdateRequest;
import com.flash.mastery.dto.response.FlashcardResponse;
import java.util.List;
import java.util.UUID;

public interface FlashcardService {
  List<FlashcardResponse> getByDeck(UUID deckId);
  FlashcardResponse getById(UUID id);
  FlashcardResponse create(FlashcardCreateRequest request);
  FlashcardResponse update(UUID id, FlashcardUpdateRequest request);
  void delete(UUID id);
}
