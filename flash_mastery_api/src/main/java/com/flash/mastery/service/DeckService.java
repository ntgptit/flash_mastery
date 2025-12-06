package com.flash.mastery.service;

import com.flash.mastery.dto.request.DeckCreateRequest;
import com.flash.mastery.dto.request.DeckUpdateRequest;
import com.flash.mastery.dto.response.DeckResponse;
import com.flash.mastery.entity.FlashcardType;
import com.flash.mastery.util.importer.ImportResult;
import java.util.List;
import java.util.UUID;
import java.io.IOException;
import org.springframework.web.multipart.MultipartFile;

public interface DeckService {
  List<DeckResponse> getDecks(UUID folderId, String sort, int page, int size, String query);
  DeckResponse getDeck(UUID id);
  DeckResponse create(DeckCreateRequest request);
  DeckResponse update(UUID id, DeckUpdateRequest request);
  void delete(UUID id);

  ImportResult<?> importDecks(UUID folderId, MultipartFile file, FlashcardType type, boolean skipHeader) throws IOException;
}
