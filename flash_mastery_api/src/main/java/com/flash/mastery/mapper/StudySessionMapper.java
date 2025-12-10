package com.flash.mastery.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import com.flash.mastery.dto.request.StudySessionUpdateRequest;
import com.flash.mastery.dto.response.StudySessionResponse;
import com.flash.mastery.entity.StudySession;

@Mapper(componentModel = "spring", uses = { DeckMapper.class, StudySessionProgressMapper.class })
public interface StudySessionMapper {
    @Mapping(target = "id", source = "id")
    @Mapping(target = "deckId", source = "deckId")
    @Mapping(target = "startedAt", source = "createdAt")
    @Mapping(target = "currentBatchIndex", source = "currentBatchIndex")
    @Mapping(target = "currentMode", source = "currentMode")
    @Mapping(target = "status", source = "status")
    @Mapping(target = "flashcardIds", source = "flashcardIds")
    @Mapping(target = "progress", source = "progress")
    @Mapping(target = "createdAt", source = "createdAt")
    @Mapping(target = "updatedAt", source = "updatedAt")
    StudySessionResponse toResponse(StudySession session);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "deckId", ignore = true)
    @Mapping(target = "deck", ignore = true)
    @Mapping(target = "flashcardIds", ignore = true)
    @Mapping(target = "status", ignore = true)
    @Mapping(target = "progress", ignore = true)
    @Mapping(target = "currentBatch", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "deletedAt", ignore = true)
    void update(@MappingTarget StudySession session, StudySessionUpdateRequest request);
}
