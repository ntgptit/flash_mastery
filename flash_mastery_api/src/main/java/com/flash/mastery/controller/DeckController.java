package com.flash.mastery.controller;

import com.flash.mastery.dto.request.DeckCreateRequest;
import com.flash.mastery.dto.request.DeckUpdateRequest;
import com.flash.mastery.dto.response.DeckResponse;
import com.flash.mastery.service.DeckService;
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
public class DeckController {

  private final DeckService deckService;

  @GetMapping
  public List<DeckResponse> list(@RequestParam(value = "folderId", required = false) UUID folderId) {
    return deckService.getDecks(folderId);
  }

  @GetMapping("/{id}")
  public DeckResponse get(@PathVariable UUID id) {
    return deckService.getDeck(id);
  }

  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  public DeckResponse create(@Valid @RequestBody DeckCreateRequest request) {
    return deckService.create(request);
  }

  @PutMapping("/{id}")
  public DeckResponse update(@PathVariable UUID id, @Valid @RequestBody DeckUpdateRequest request) {
    return deckService.update(id, request);
  }

  @DeleteMapping("/{id}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(@PathVariable UUID id) {
    deckService.delete(id);
  }
}
