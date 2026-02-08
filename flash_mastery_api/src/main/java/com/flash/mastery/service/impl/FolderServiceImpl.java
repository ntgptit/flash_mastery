package com.flash.mastery.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.UUID;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.flash.mastery.constant.ErrorCodes;
import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.dto.criteria.FolderSearchCriteria;
import com.flash.mastery.dto.request.FolderCreateRequest;
import com.flash.mastery.dto.request.FolderUpdateRequest;
import com.flash.mastery.dto.response.FolderResponse;
import com.flash.mastery.entity.Folder;
import com.flash.mastery.exception.BadRequestException;
import com.flash.mastery.exception.NotFoundException;
import com.flash.mastery.mapper.FolderMapper;
import com.flash.mastery.repository.FolderRepository;
import com.flash.mastery.service.BaseService;
import com.flash.mastery.service.FolderService;

@Service
@Transactional
public class FolderServiceImpl extends BaseService implements FolderService {

    private final FolderRepository folderRepository;
    private final FolderMapper folderMapper;

    public FolderServiceImpl(
            FolderRepository folderRepository,
            FolderMapper folderMapper,
            MessageSource messageSource) {
        super(messageSource);
        this.folderRepository = folderRepository;
        this.folderMapper = folderMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public List<FolderResponse> getFolders(UUID parentId) {
        final var criteria = FolderSearchCriteria.builder()
                .parentId(parentId)
                .build();

        // Validate parent exists if filter is applied
        if (criteria.hasParentFilter()) {
            findByIdOrThrow(
                    this.folderRepository.findById(criteria.getParentId()),
                    ErrorCodes.FOLDER_NOT_FOUND, MessageKeys.ERROR_FOLDER_NOT_FOUND);
        }

        final var folders = this.folderRepository.findByCriteria(criteria);
        return folders.stream().map(this::toResponseWithPath).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public FolderResponse getFolder(UUID id) {
        final var folder = findByIdOrThrow(
                this.folderRepository.findById(id),
                ErrorCodes.FOLDER_NOT_FOUND, MessageKeys.ERROR_FOLDER_NOT_FOUND);
        return toResponseWithPath(folder);
    }

    @Override
    public FolderResponse create(FolderCreateRequest request) {
        final var folder = this.folderMapper.fromCreate(request);
        if (request.getParentId() != null) {
            final var parent = this.folderRepository
                    .findById(request.getParentId())
                    .orElseThrow(() -> new NotFoundException(
                            ErrorCodes.FOLDER_NOT_FOUND, MessageKeys.ERROR_FOLDER_NOT_FOUND));
            folder.setParent(parent);
        }
        final var saved = this.folderRepository.save(folder);
        return toResponseWithPath(saved);
    }

    @Override
    public FolderResponse update(UUID id, FolderUpdateRequest request) {
        final var folder = findByIdOrThrow(
                this.folderRepository.findById(id),
                ErrorCodes.FOLDER_NOT_FOUND, MessageKeys.ERROR_FOLDER_NOT_FOUND);
        if (request.getParentId() != null) {
            if (id.equals(request.getParentId())) {
                throw new BadRequestException(
                        ErrorCodes.FOLDER_SELF_REFERENCE, MessageKeys.ERROR_FOLDER_SELF_REFERENCE);
            }
            final var parent = this.folderRepository
                    .findById(request.getParentId())
                    .orElseThrow(() -> new NotFoundException(
                            ErrorCodes.FOLDER_NOT_FOUND, MessageKeys.ERROR_FOLDER_NOT_FOUND));
            validateParent(folder, parent);
            folder.setParent(parent);
        }
        this.folderMapper.update(folder, request);
        final var saved = this.folderRepository.save(folder);
        return toResponseWithPath(saved);
    }

    @Override
    public void delete(UUID id) {
        final var folder = findByIdOrThrow(
                this.folderRepository.findById(id),
                ErrorCodes.FOLDER_NOT_FOUND, MessageKeys.ERROR_FOLDER_NOT_FOUND);
        // Recursively delete all subfolders and their contents
        deleteRecursively(folder);
    }

    private void deleteRecursively(Folder folder) {
        // Delete all children folders recursively
        for (final var child : new HashSet<>(folder.getChildren())) {
            deleteRecursively(child);
        }
        // After all children are deleted, delete this folder
        // (cascade will handle decks due to JPA relationship)
        this.folderRepository.delete(folder);
    }

    private void validateParent(Folder folder, Folder newParent) {
        var current = newParent;
        while (current != null) {
            if ((folder.getId() != null) && folder.getId().equals(current.getId())) {
                throw new BadRequestException(
                        ErrorCodes.FOLDER_CIRCULAR_PARENT, MessageKeys.ERROR_FOLDER_CIRCULAR_PARENT);
            }
            current = current.getParent();
        }
    }

    private FolderResponse toResponseWithPath(Folder folder) {
        final var base = this.folderMapper.toResponse(folder);
        final var path = buildPath(folder);
        final var level = Math.max(0, path.size() - 1);
        return base.toBuilder().path(path).level(level).build();
    }

    private List<String> buildPath(Folder folder) {
        final List<String> path = new ArrayList<>();
        var current = folder;
        var guard = 0;
        while ((current != null) && (guard < 100)) {
            path.add(current.getName());
            current = current.getParent();
            guard++;
        }
        Collections.reverse(path);
        return path;
    }
}
