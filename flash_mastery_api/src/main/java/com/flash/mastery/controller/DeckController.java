package com.flash.mastery.controller;

import com.flash.mastery.dto.request.DeckCreateRequest;
import com.flash.mastery.dto.request.DeckUpdateRequest;
import com.flash.mastery.dto.response.DeckResponse;
import com.flash.mastery.service.DeckService;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/decks")
@RequiredArgsConstructor
@Tag(name = "Decks", description = "Manage decks")
public class DeckController {

  private final DeckService deckService;

  @GetMapping
  @Operation(summary = "List decks", description = "Optionally filter by folder", responses = @ApiResponse(responseCode = "200", description = "List of decks"))
  public List<DeckResponse> list(@RequestParam(value = "folderId", required = false) UUID folderId) {
    return deckService.getDecks(folderId);
  }

  @GetMapping("/{id}")
  @Operation(
      summary = "Get deck detail",
      responses = {
        @ApiResponse(responseCode = "200", description = "Deck found"),
        @ApiResponse(responseCode = "404", description = "Deck not found", content = @Content(schema = @Schema(hidden = true)))
      })
  public DeckResponse get(@PathVariable UUID id) {
    return deckService.getDeck(id);
  }

  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  @Operation(summary = "Create deck", responses = @ApiResponse(responseCode = "201", description = "Deck created"))
  public DeckResponse create(@Valid @RequestBody DeckCreateRequest request) {
    return deckService.create(request);
  }

  @PutMapping("/{id}")
  @Operation(
      summary = "Update deck",
      responses = {
        @ApiResponse(responseCode = "200", description = "Deck updated"),
        @ApiResponse(responseCode = "404", description = "Deck not found", content = @Content(schema = @Schema(hidden = true)))
      })
  public DeckResponse update(@PathVariable UUID id, @Valid @RequestBody DeckUpdateRequest request) {
    return deckService.update(id, request);
  }

  @DeleteMapping("/{id}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  @Operation(
      summary = "Delete deck",
      responses = {
        @ApiResponse(responseCode = "204", description = "Deck deleted"),
        @ApiResponse(responseCode = "404", description = "Deck not found", content = @Content(schema = @Schema(hidden = true)))
      })
  public void delete(@PathVariable UUID id) {
    deckService.delete(id);
  }
}
