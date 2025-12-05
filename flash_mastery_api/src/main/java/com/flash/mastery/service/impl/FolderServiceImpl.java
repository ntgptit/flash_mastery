package com.flash.mastery.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.dto.request.FolderCreateRequest;
import com.flash.mastery.dto.request.FolderUpdateRequest;
import com.flash.mastery.dto.response.FolderResponse;
import com.flash.mastery.entity.Folder;
import com.flash.mastery.exception.NotFoundException;
import com.flash.mastery.mapper.FolderMapper;
import com.flash.mastery.repository.FolderRepository;
import com.flash.mastery.service.FolderService;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class FolderServiceImpl implements FolderService {

    private final FolderRepository folderRepository;
    private final FolderMapper folderMapper;
    private final MessageSource messageSource;

    @Override
    @Transactional(readOnly = true)
    public List<FolderResponse> getFolders(UUID parentId) {
        List<Folder> folders;
        if (parentId == null) {
            folders = this.folderRepository.findAll();
        } else {
            this.folderRepository
                    .findById(parentId)
                    .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
            folders = this.folderRepository.findByParentId(parentId);
        }
        return folders.stream().map(this::toResponseWithPath).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public FolderResponse getFolder(UUID id) {
        final var folder = this.folderRepository.findById(id).orElseThrow(() -> new NotFoundException(msg(
                MessageKeys.ERROR_NOT_FOUND_FOLDER)));
        return toResponseWithPath(folder);
    }

    @Override
    public FolderResponse create(FolderCreateRequest request) {
        final var folder = this.folderMapper.fromCreate(request);
        if (request.getParentId() != null) {
            final var parent = this.folderRepository
                    .findById(request.getParentId())
                    .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
            folder.setParent(parent);
        }
        final var saved = this.folderRepository.save(folder);
        return toResponseWithPath(saved);
    }

    @Override
    public FolderResponse update(UUID id, FolderUpdateRequest request) {
        final var folder = this.folderRepository.findById(id).orElseThrow(() -> new NotFoundException(msg(
                MessageKeys.ERROR_NOT_FOUND_FOLDER)));
        if (request.getParentId() != null) {
            if (id.equals(request.getParentId())) {
                throw new IllegalArgumentException("Folder cannot reference itself as parent");
            }
            final var parent = this.folderRepository
                    .findById(request.getParentId())
                    .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
            validateParent(folder, parent);
            folder.setParent(parent);
        }
        this.folderMapper.update(folder, request);
        final var saved = this.folderRepository.save(folder);
        return toResponseWithPath(saved);
    }

    @Override
    public void delete(UUID id) {
        final var folder = this.folderRepository.findById(id).orElseThrow(() -> new NotFoundException(msg(
                MessageKeys.ERROR_NOT_FOUND_FOLDER)));
        if (!folder.getChildren().isEmpty()) {
            throw new IllegalArgumentException("Cannot delete a folder that contains subfolders");
        }
        this.folderRepository.delete(folder);
    }

    private String msg(String key) {
        return this.messageSource.getMessage(key, null, LocaleContextHolder.getLocale());
    }

    private void validateParent(Folder folder, Folder newParent) {
        var current = newParent;
        while (current != null) {
            if ((folder.getId() != null) && folder.getId().equals(current.getId())) {
                throw new IllegalArgumentException("Parent folder cannot be a descendant of the folder");
            }
            current = current.getParent();
        }
    }

    private FolderResponse toResponseWithPath(Folder folder) {
        final var base = this.folderMapper.toResponse(folder);
        final var path = buildPath(folder);
        final int level = Math.max(0, path.size() - 1);
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
