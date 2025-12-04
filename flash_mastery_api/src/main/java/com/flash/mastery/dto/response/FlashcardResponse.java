package com.flash.mastery.dto.response;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;
import lombok.extern.jackson.Jacksonized;

@Value
@Builder
@Jacksonized
@AllArgsConstructor(access = AccessLevel.PUBLIC)
public class FlashcardResponse {
  UUID id;
  UUID deckId;
  String question;
  String answer;
  String hint;
  LocalDateTime createdAt;
  LocalDateTime updatedAt;
}
