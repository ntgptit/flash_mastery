package com.flash.mastery.dto.response;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

import com.flash.mastery.entity.enums.StudyMode;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Value;
import lombok.extern.jackson.Jacksonized;

@Value
@Builder
@Jacksonized
@AllArgsConstructor(access = AccessLevel.PUBLIC)
public class StudySessionProgressResponse {
    UUID id;
    UUID flashcardId;
    Map<StudyMode, Boolean> modeCompletion;
    Integer correctAnswers;
    Integer totalAttempts;
    LocalDateTime lastStudiedAt;
}
