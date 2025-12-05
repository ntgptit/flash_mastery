package com.flash.mastery.mapper;

import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.dto.request.FolderCreateRequest;
import com.flash.mastery.dto.request.FolderUpdateRequest;
import com.flash.mastery.dto.response.FolderResponse;
import com.flash.mastery.entity.Folder;
import org.mapstruct.BeanMapping;
import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

@Mapper(componentModel = "spring", builder = @Builder(disableBuilder = true), imports = NumberConstants.class)
public interface FolderMapper {

  FolderResponse toResponse(Folder entity);

  @Mapping(target = "id", ignore = true)
  @Mapping(target = "name", source = "request.name")
  @Mapping(target = "description", source = "request.description")
  @Mapping(target = "color", source = "request.color")
  @Mapping(target = "deckCount", expression = "java(NumberConstants.ZERO)")
  @Mapping(target = "decks", ignore = true)
  @Mapping(target = "createdAt", ignore = true)
  @Mapping(target = "updatedAt", ignore = true)
  Folder fromCreate(FolderCreateRequest request);

  @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
  @Mapping(target = "id", ignore = true)
  @Mapping(target = "createdAt", ignore = true)
  @Mapping(target = "updatedAt", ignore = true)
  @Mapping(target = "deckCount", ignore = true)
  @Mapping(target = "decks", ignore = true)
  void update(@MappingTarget Folder folder, FolderUpdateRequest request);
}
