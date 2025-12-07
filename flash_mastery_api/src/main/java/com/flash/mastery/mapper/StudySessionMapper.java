package com.flash.mastery.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import com.flash.mastery.dto.request.StudySessionUpdateRequest;
import com.flash.mastery.dto.response.StudySessionResponse;
import com.flash.mastery.entity.StudySession;

@Mapper(componentModel = "spring", uses = { DeckMapper.class })
public interface StudySessionMapper {
    @Mapping(target = "id", source = "id")
    @Mapping(target = "deckId", source = "deck.id")
    @Mapping(target = "startedAt", source = "createdAt")
    @Mapping(target = "completedAt", source = "completedAt")
    @Mapping(target = "currentBatchIndex", source = "currentBatchIndex")
    @Mapping(target = "currentMode", source = "currentMode")
    @Mapping(target = "flashcardIds", source = "flashcardIds")
    @Mapping(target = "progressData", source = "progressData")
    @Mapping(target = "createdAt", source = "createdAt")
    @Mapping(target = "updatedAt", source = "updatedAt")
    StudySessionResponse toResponse(StudySession session);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "deck", ignore = true)
    @Mapping(target = "flashcardIds", ignore = true)
    @Mapping(target = "completedAt", ignore = true)
    @Mapping(target = "currentBatch", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    void update(@MappingTarget StudySession session, StudySessionUpdateRequest request);
}
