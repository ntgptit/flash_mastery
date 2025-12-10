package com.flash.mastery.dto.request;

import java.util.List;

import com.flash.mastery.entity.enums.StudyMode;

import lombok.Data;

@Data
public class StudySessionUpdateRequest {
    private StudyMode currentMode;
    private Integer currentBatchIndex;
    private List<StudySessionProgressUpdate> progressUpdates;
}

