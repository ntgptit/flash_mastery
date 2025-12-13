package com.flash.mastery.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import com.flash.mastery.dto.request.StudySessionUpdateRequest;
import com.flash.mastery.dto.response.StudySessionProgressResponse;
import com.flash.mastery.dto.response.StudySessionResponse;
import com.flash.mastery.entity.StudySessionProgress;
import com.flash.mastery.entity.StudySession;
import com.flash.mastery.entity.enums.StudyMode;

import java.util.EnumMap;
import java.util.List;
import java.util.Map;

@Mapper(componentModel = "spring", uses = { DeckMapper.class })
public interface StudySessionMapper {
    @Mapping(target = "id", source = "id")
    @Mapping(target = "deckId", source = "deck.id")
    @Mapping(target = "startedAt", source = "createdAt")
    @Mapping(target = "completedAt", source = "completedAt")
    @Mapping(target = "currentBatchIndex", source = "currentBatchIndex")
    @Mapping(target = "currentMode", source = "currentMode")
    @Mapping(target = "nextMode", source = "nextMode")
    @Mapping(target = "status", source = "status")
    @Mapping(target = "flashcardIds", source = "flashcardIds")
    @Mapping(target = "progress", expression = "java(mapProgress(session.getProgressRecords()))")
    @Mapping(target = "createdAt", source = "createdAt")
    @Mapping(target = "updatedAt", source = "updatedAt")
    StudySessionResponse toResponse(StudySession session);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "deck", ignore = true)
    @Mapping(target = "flashcardIds", ignore = true)
    @Mapping(target = "status", ignore = true)
    @Mapping(target = "completedAt", ignore = true)
    @Mapping(target = "currentBatch", ignore = true)
    @Mapping(target = "progressRecords", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    void update(@MappingTarget StudySession session, StudySessionUpdateRequest request);

    default List<StudySessionProgressResponse> mapProgress(List<StudySessionProgress> progressRecords) {
        if (progressRecords == null) {
            return List.of();
        }
        return progressRecords.stream()
                .map(this::toProgressResponse)
                .toList();
    }

    default StudySessionProgressResponse toProgressResponse(StudySessionProgress progress) {
        return StudySessionProgressResponse.builder()
                .id(progress.getId())
                .flashcardId(progress.getFlashcard().getId())
                .modeCompletion(toModeCompletionMap(progress))
                .correctAnswers(progress.getCorrectAnswers())
                .totalAttempts(progress.getTotalAttempts())
                .lastStudiedAt(progress.getLastStudiedAt())
                .build();
    }

    default Map<StudyMode, Boolean> toModeCompletionMap(StudySessionProgress progress) {
        final Map<StudyMode, Boolean> map = new EnumMap<>(StudyMode.class);
        map.put(StudyMode.OVERVIEW, progress.isOverviewCompleted());
        map.put(StudyMode.MATCHING, progress.isMatchingCompleted());
        map.put(StudyMode.GUESS, progress.isGuessCompleted());
        map.put(StudyMode.RECALL, progress.isRecallCompleted());
        map.put(StudyMode.FILL_IN_BLANK, progress.isFillInBlankCompleted());
        return map;
    }
}
