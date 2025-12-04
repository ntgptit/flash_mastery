package com.flash.mastery.mapper;

import com.flash.mastery.dto.request.FlashcardCreateRequest;
import com.flash.mastery.dto.request.FlashcardUpdateRequest;
import com.flash.mastery.dto.response.FlashcardResponse;
import com.flash.mastery.entity.Deck;
import com.flash.mastery.entity.Flashcard;
import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import org.mapstruct.Builder;

@Mapper(componentModel = "spring", uses = {DeckMapper.class}, builder = @Builder(disableBuilder = true))
public interface FlashcardMapper {

  @Mapping(target = "deckId", source = "deck.id")
  FlashcardResponse toResponse(Flashcard entity);

  @Mapping(target = "id", ignore = true)
  @Mapping(target = "deck", source = "deck")
  @Mapping(target = "question", source = "request.question")
  @Mapping(target = "answer", source = "request.answer")
  @Mapping(target = "hint", source = "request.hint")
  @Mapping(target = "createdAt", ignore = true)
  @Mapping(target = "updatedAt", ignore = true)
  Flashcard fromCreate(FlashcardCreateRequest request, Deck deck);

  @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
  @Mapping(target = "deck", ignore = true)
  void update(@MappingTarget Flashcard flashcard, FlashcardUpdateRequest request);
}
