package com.flash.mastery.mapper;

import org.mapstruct.BeanMapping;
import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import com.flash.mastery.dto.request.FlashcardCreateRequest;
import com.flash.mastery.dto.request.FlashcardUpdateRequest;
import com.flash.mastery.dto.response.FlashcardResponse;
import com.flash.mastery.entity.Deck;
import com.flash.mastery.entity.Flashcard;

@Mapper(componentModel = "spring", uses = { DeckMapper.class }, builder = @Builder(disableBuilder = true))
public interface FlashcardMapper {

    @Mapping(target = "deckId", source = "deck.id")
    @Mapping(target = "type", expression = "java(entity.getType() != null ? entity.getType() : com.flash.mastery.entity.FlashcardType.VOCABULARY)")
    FlashcardResponse toResponse(Flashcard entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "deck", source = "deck")
    @Mapping(target = "question", source = "request.question")
    @Mapping(target = "answer", source = "request.answer")
    @Mapping(target = "hint", source = "request.hint")
    @Mapping(target = "type", expression = "java(request.getType() != null ? request.getType() : FlashcardType.VOCABULARY)")
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    Flashcard fromCreate(FlashcardCreateRequest request, Deck deck);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "deck", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "type", expression = "java(request.getType() != null ? request.getType() : flashcard.getType())")
    void update(@MappingTarget Flashcard flashcard, FlashcardUpdateRequest request);
}
