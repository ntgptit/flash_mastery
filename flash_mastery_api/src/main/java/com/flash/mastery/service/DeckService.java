package com.flash.mastery.service;

import com.flash.mastery.dto.request.DeckCreateRequest;
import com.flash.mastery.dto.request.DeckUpdateRequest;
import com.flash.mastery.dto.response.DeckResponse;
import java.util.List;
import java.util.UUID;

public interface DeckService {
  List<DeckResponse> getDecks(UUID folderId);
  DeckResponse getDeck(UUID id);
  DeckResponse create(DeckCreateRequest request);
  DeckResponse update(UUID id, DeckUpdateRequest request);
  void delete(UUID id);
}
