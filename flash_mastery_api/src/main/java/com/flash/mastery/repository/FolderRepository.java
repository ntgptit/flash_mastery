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

    List<Folder> findByParentId(@Param(RepositoryConstants.PARAM_PARENT_ID) UUID parentId);

    List<Folder> findByParentIsNull();

    long countByParentId(@Param(RepositoryConstants.PARAM_PARENT_ID) UUID parentId);

    void insert(Folder folder);

    void update(Folder folder);

    void deleteById(@Param(RepositoryConstants.PARAM_ID) UUID id);
}
