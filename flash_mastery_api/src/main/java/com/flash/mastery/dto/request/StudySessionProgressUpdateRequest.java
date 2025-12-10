package com.flash.mastery.dto.request;

import java.util.List;
import java.util.UUID;

import com.flash.mastery.entity.enums.StudyMode;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class StudySessionProgressUpdateRequest {
    @NotNull
    private UUID flashcardId;

    private List<StudyMode> completedModes;

    private Integer correctAnswers;

    private Integer totalAttempts;
}
