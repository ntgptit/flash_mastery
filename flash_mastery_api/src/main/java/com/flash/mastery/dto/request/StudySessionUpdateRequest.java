package com.flash.mastery.dto.request;

import java.util.Map;
import java.util.UUID;

import com.flash.mastery.entity.enums.StudyMode;

import lombok.Data;

@Data
public class StudySessionUpdateRequest {
    private StudyMode currentMode;
    private Integer currentBatchIndex;
    private Map<UUID, String> progressData; // flashcardId -> progress string
}

