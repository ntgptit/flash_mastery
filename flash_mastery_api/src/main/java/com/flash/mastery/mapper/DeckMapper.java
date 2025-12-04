package com.flash.mastery.mapper;

import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.dto.request.DeckCreateRequest;
import com.flash.mastery.dto.request.DeckUpdateRequest;
import com.flash.mastery.dto.response.DeckResponse;
import com.flash.mastery.entity.Deck;
import com.flash.mastery.entity.Folder;
import org.mapstruct.BeanMapping;
import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

@Mapper(
    componentModel = "spring",
    uses = {FolderMapper.class},
    builder = @Builder(disableBuilder = true),
    imports = NumberConstants.class)
public interface DeckMapper {

  @Mapping(target = "folderId", source = "folder.id")
  DeckResponse toResponse(Deck entity);

  @Mapping(target = "id", ignore = true)
  @Mapping(target = "name", source = "request.name")
  @Mapping(target = "description", source = "request.description")
  @Mapping(target = "cardCount", expression = "java(NumberConstants.ZERO)")
  @Mapping(target = "folder", source = "folder")
  @Mapping(target = "flashcards", ignore = true)
  @Mapping(target = "createdAt", ignore = true)
  @Mapping(target = "updatedAt", ignore = true)
  Deck fromCreate(DeckCreateRequest request, Folder folder);

  @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
  @Mapping(target = "name", source = "request.name")
  @Mapping(target = "description", source = "request.description")
  @Mapping(target = "folder", source = "folder")
  void update(@MappingTarget Deck deck, DeckUpdateRequest request, Folder folder);
}
