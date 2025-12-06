package com.flash.mastery.mapper;

import org.mapstruct.BeanMapping;
import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import com.flash.mastery.constant.NumberConstants;
import com.flash.mastery.dto.request.FolderCreateRequest;
import com.flash.mastery.dto.request.FolderUpdateRequest;
import com.flash.mastery.dto.response.FolderResponse;
import com.flash.mastery.entity.Folder;

@Mapper(componentModel = "spring", builder = @Builder(disableBuilder = true), imports = NumberConstants.class)
public interface FolderMapper {

    @Mapping(target = "parentId", expression = "java(entity.getParent() != null ? entity.getParent().getId() : null)")
    @Mapping(target = "subFolderCount", expression = "java(entity.getChildren() != null ? entity.getChildren().size() : NumberConstants.ZERO)")
    @Mapping(target = "path", ignore = true)
    @Mapping(target = "level", ignore = true)
    FolderResponse toResponse(Folder entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "name", source = "request.name")
    @Mapping(target = "description", source = "request.description")
    @Mapping(target = "color", source = "request.color")
    @Mapping(target = "deckCount", expression = "java(NumberConstants.ZERO)")
    @Mapping(target = "parent", ignore = true)
    @Mapping(target = "decks", ignore = true)
    @Mapping(target = "children", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    Folder fromCreate(FolderCreateRequest request);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "deckCount", ignore = true)
    @Mapping(target = "parent", ignore = true)
    @Mapping(target = "decks", ignore = true)
    @Mapping(target = "children", ignore = true)
    void update(@MappingTarget Folder folder, FolderUpdateRequest request);
}
