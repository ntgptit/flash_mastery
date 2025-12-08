package com.flash.mastery.repository;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.flash.mastery.constant.RepositoryConstants;
import com.flash.mastery.entity.Deck;

@Mapper
public interface DeckRepository {

    Deck findById(@Param(RepositoryConstants.PARAM_ID) UUID id);

    List<Deck> findAll(@Param(RepositoryConstants.PARAM_OFFSET) int offset,
            @Param(RepositoryConstants.PARAM_LIMIT) int limit);

    List<Deck> findByFolderId(@Param(RepositoryConstants.PARAM_FOLDER_ID) UUID folderId,
            @Param(RepositoryConstants.PARAM_OFFSET) int offset,
            @Param(RepositoryConstants.PARAM_LIMIT) int limit);

    List<Deck> findByNameContainingIgnoreCase(@Param(RepositoryConstants.PARAM_NAME) String name,
            @Param(RepositoryConstants.PARAM_OFFSET) int offset,
            @Param(RepositoryConstants.PARAM_LIMIT) int limit);

    List<Deck> findByFolderIdAndNameContainingIgnoreCase(@Param(RepositoryConstants.PARAM_FOLDER_ID) UUID folderId,
            @Param(RepositoryConstants.PARAM_NAME) String name,
            @Param(RepositoryConstants.PARAM_OFFSET) int offset, @Param(RepositoryConstants.PARAM_LIMIT) int limit);

    boolean existsByFolderIdAndNameIgnoreCase(@Param(RepositoryConstants.PARAM_FOLDER_ID) UUID folderId,
            @Param(RepositoryConstants.PARAM_NAME) String name);

    long count();

    long countByFolderId(@Param(RepositoryConstants.PARAM_FOLDER_ID) UUID folderId);

    long countByNameContainingIgnoreCase(@Param(RepositoryConstants.PARAM_NAME) String name);

    long countByFolderIdAndNameContainingIgnoreCase(@Param(RepositoryConstants.PARAM_FOLDER_ID) UUID folderId,
            @Param(RepositoryConstants.PARAM_NAME) String name);

    void insert(Deck deck);

    void update(Deck deck);

    void deleteById(@Param(RepositoryConstants.PARAM_ID) UUID id);
}
