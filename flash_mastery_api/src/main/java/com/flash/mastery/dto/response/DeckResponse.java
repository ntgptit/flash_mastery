package com.flash.mastery.dto.response;

import java.time.LocalDateTime;
import java.util.UUID;
import com.flash.mastery.entity.FlashcardType;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;
import lombok.extern.jackson.Jacksonized;

@Value
@Builder
@Jacksonized
@AllArgsConstructor(access = AccessLevel.PUBLIC)
public class DeckResponse {
  UUID id;
  String name;
  String description;
  UUID folderId;
  int cardCount;
  FlashcardType type;
  LocalDateTime createdAt;
  LocalDateTime updatedAt;
}
