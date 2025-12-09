package com.flash.mastery.dto.response;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.flash.mastery.entity.enums.StudyMode;
import com.flash.mastery.entity.enums.StudySessionStatus;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;
import lombok.extern.jackson.Jacksonized;

@Value
@Builder
@Jacksonized
@AllArgsConstructor(access = AccessLevel.PUBLIC)
public class StudySessionResponse {
    UUID id;
    UUID deckId;
    List<UUID> flashcardIds;
    StudyMode currentMode;
    Integer currentBatchIndex;
    StudySessionStatus status;
    Map<UUID, String> progressData;
    LocalDateTime startedAt;
    LocalDateTime createdAt;
    LocalDateTime updatedAt;
}

