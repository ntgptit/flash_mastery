package com.flash.mastery.controller;

import com.flash.mastery.dto.request.FlashcardCreateRequest;
import com.flash.mastery.dto.request.FlashcardUpdateRequest;
import com.flash.mastery.dto.response.FlashcardResponse;
import com.flash.mastery.service.FlashcardService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class FlashcardController {

  private final FlashcardService flashcardService;

  @GetMapping("/decks/{deckId}/cards")
  public List<FlashcardResponse> listByDeck(@PathVariable UUID deckId) {
    return flashcardService.getByDeck(deckId);
  }

  @GetMapping("/cards/{id}")
  public FlashcardResponse get(@PathVariable UUID id) {
    return flashcardService.getById(id);
  }

  @PostMapping("/decks/{deckId}/cards")
  @ResponseStatus(HttpStatus.CREATED)
  public FlashcardResponse create(@PathVariable UUID deckId, @Valid @RequestBody FlashcardCreateRequest request) {
    request.setDeckId(deckId);
    return flashcardService.create(request);
  }

  @PutMapping("/cards/{id}")
  public FlashcardResponse update(@PathVariable UUID id, @Valid @RequestBody FlashcardUpdateRequest request) {
    return flashcardService.update(id, request);
  }

  @DeleteMapping("/cards/{id}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(@PathVariable UUID id) {
    flashcardService.delete(id);
  }
}
