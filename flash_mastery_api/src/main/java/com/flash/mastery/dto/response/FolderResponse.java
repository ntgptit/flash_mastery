package com.flash.mastery.dto.response;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;
import lombok.extern.jackson.Jacksonized;

@Value
@Builder(toBuilder = true)
@Jacksonized
@AllArgsConstructor(access = AccessLevel.PUBLIC)
public class FolderResponse {
  UUID id;
  String name;
  String description;
  String color;
  int deckCount;
  UUID parentId;
  int subFolderCount;
  int level;
  List<String> path;
  LocalDateTime createdAt;
  LocalDateTime updatedAt;
}
