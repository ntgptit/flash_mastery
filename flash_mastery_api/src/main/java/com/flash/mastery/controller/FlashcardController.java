package com.flash.mastery.controller;

import com.flash.mastery.dto.request.FlashcardCreateRequest;
import com.flash.mastery.dto.request.FlashcardUpdateRequest;
import com.flash.mastery.dto.response.FlashcardResponse;
import com.flash.mastery.service.FlashcardService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
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
@Tag(name = "Flashcards", description = "Manage flashcards")
public class FlashcardController {

  private final FlashcardService flashcardService;

  @GetMapping("/decks/{deckId}/cards")
  @Operation(summary = "List flashcards by deck", responses = @ApiResponse(responseCode = "200", description = "List of flashcards"))
  public List<FlashcardResponse> listByDeck(@PathVariable UUID deckId) {
    return flashcardService.getByDeck(deckId);
  }

  @GetMapping("/cards/{id}")
  @Operation(
      summary = "Get flashcard detail",
      responses = {
        @ApiResponse(responseCode = "200", description = "Flashcard found"),
        @ApiResponse(responseCode = "404", description = "Flashcard not found", content = @Content(schema = @Schema(hidden = true)))
      })
  public FlashcardResponse get(@PathVariable UUID id) {
    return flashcardService.getById(id);
  }

  @PostMapping("/decks/{deckId}/cards")
  @ResponseStatus(HttpStatus.CREATED)
  @Operation(
      summary = "Create flashcard under deck",
      responses = @ApiResponse(responseCode = "201", description = "Flashcard created"))
  public FlashcardResponse create(@PathVariable UUID deckId, @Valid @RequestBody FlashcardCreateRequest request) {
    request.setDeckId(deckId);
    return flashcardService.create(request);
  }

  @PutMapping("/cards/{id}")
  @Operation(
      summary = "Update flashcard",
      responses = {
        @ApiResponse(responseCode = "200", description = "Flashcard updated"),
        @ApiResponse(responseCode = "404", description = "Flashcard not found", content = @Content(schema = @Schema(hidden = true)))
      })
  public FlashcardResponse update(@PathVariable UUID id, @Valid @RequestBody FlashcardUpdateRequest request) {
    return flashcardService.update(id, request);
  }

  @DeleteMapping("/cards/{id}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  @Operation(
      summary = "Delete flashcard",
      responses = {
        @ApiResponse(responseCode = "204", description = "Flashcard deleted"),
        @ApiResponse(responseCode = "404", description = "Flashcard not found", content = @Content(schema = @Schema(hidden = true)))
      })
  public void delete(@PathVariable UUID id) {
    flashcardService.delete(id);
  }
}
