package com.flash.mastery.repository;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.flash.mastery.constant.RepositoryConstants;
import com.flash.mastery.entity.Folder;

@Mapper
public interface FolderRepository {

    Folder findById(@Param(RepositoryConstants.PARAM_ID) UUID id);

    List<Folder> findAll();

    /**
     * Search folders by parentId using dynamic SQL.
     * If parentId is null, returns root folders (parent_id IS NULL).
     * If parentId is provided, returns child folders (parent_id = parentId).
     */
    List<Folder> searchByParent(@Param(RepositoryConstants.PARAM_PARENT_ID) UUID parentId);

    long countByParentId(@Param(RepositoryConstants.PARAM_PARENT_ID) UUID parentId);

    void insert(Folder folder);

    void update(Folder folder);

    void deleteById(@Param(RepositoryConstants.PARAM_ID) UUID id);
}
