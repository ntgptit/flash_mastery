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
public class FolderResponse {
  UUID id;
  String name;
  String description;
  String color;
  int deckCount;
  LocalDateTime createdAt;
  LocalDateTime updatedAt;
}
