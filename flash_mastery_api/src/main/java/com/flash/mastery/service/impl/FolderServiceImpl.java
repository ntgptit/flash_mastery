package com.flash.mastery.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.constant.RepositoryConstants;
import com.flash.mastery.dto.criteria.FolderSearchCriteria;
import com.flash.mastery.dto.request.FolderCreateRequest;
import com.flash.mastery.dto.request.FolderUpdateRequest;
import com.flash.mastery.dto.response.FolderResponse;
import com.flash.mastery.entity.Folder;
import com.flash.mastery.exception.NotFoundException;
import com.flash.mastery.mapper.FolderMapper;
import com.flash.mastery.repository.DeckRepository;
import com.flash.mastery.repository.FolderRepository;
import com.flash.mastery.service.BaseService;
import com.flash.mastery.service.FolderService;

@Service
@Transactional
public class FolderServiceImpl extends BaseService implements FolderService {

    private final FolderRepository folderRepository;
    private final DeckRepository deckRepository;
    private final FolderMapper folderMapper;

    public FolderServiceImpl(
            FolderRepository folderRepository,
            DeckRepository deckRepository,
            FolderMapper folderMapper,
            MessageSource messageSource) {
        super(messageSource);
        this.folderRepository = folderRepository;
        this.deckRepository = deckRepository;
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
            final var parent = this.folderRepository.findById(criteria.getParentId());
            if (parent == null) {
                throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER));
            }
        }

        // Execute search based on criteria
        final List<Folder> folders;
        if (criteria.isRootFolders()) {
            folders = this.folderRepository.findByParentIsNull();
        } else if (criteria.hasParentFilter()) {
            folders = this.folderRepository.findByParentId(criteria.getParentId());
        } else {
            folders = this.folderRepository.findByParentIsNull();
        }

        return folders.stream().map(this::toResponseWithPath).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public FolderResponse getFolder(UUID id) {
        final var folder = this.folderRepository.findById(id);
        if (folder == null) {
            throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER));
        }
        return toResponseWithPath(folder);
    }

    @Override
    public FolderResponse create(FolderCreateRequest request) {
        final var folder = this.folderMapper.fromCreate(request);
        if (request.getParentId() != null) {
            final var parent = this.folderRepository.findById(request.getParentId());
            if (parent == null) {
                throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER));
            }
            folder.setParentId(request.getParentId());
            folder.setParent(parent);
        }

        // Initialize entity
        folder.onCreate();
        this.folderRepository.insert(folder);

        return toResponseWithPath(folder);
    }

    @Override
    public FolderResponse update(UUID id, FolderUpdateRequest request) {
        final var folder = this.folderRepository.findById(id);
        if (folder == null) {
            throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER));
        }

        if (request.getParentId() != null) {
            if (id.equals(request.getParentId())) {
                throw new IllegalArgumentException(msg(MessageKeys.ERROR_FOLDER_CANNOT_REFERENCE_ITSELF));
            }
            final var parent = this.folderRepository.findById(request.getParentId());
            if (parent == null) {
                throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER));
            }
            validateParent(folder, parent);
            folder.setParentId(request.getParentId());
            folder.setParent(parent);
        }

        this.folderMapper.update(folder, request);
        folder.onUpdate();
        this.folderRepository.update(folder);

        return toResponseWithPath(folder);
    }

    @Override
    public void delete(UUID id) {
        final var folder = this.folderRepository.findById(id);
        if (folder == null) {
            throw new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER));
        }
        // Recursively delete all subfolders and their contents
        deleteRecursively(id);
    }

    private void deleteRecursively(UUID folderId) {
        // Load children folders
        final var children = this.folderRepository.findByParentId(folderId);

        // Delete all children folders recursively
        for (final var child : children) {
            deleteRecursively(child.getId());
        }

        // Soft delete all decks in this folder before deleting the folder
        // This prevents foreign key constraint violations
        this.deckRepository.deleteByFolderId(folderId);

        // Soft delete this folder (sets deleted_at timestamp)
        this.folderRepository.deleteById(folderId);
    }

    private void validateParent(Folder folder, Folder newParent) {
        var current = newParent;
        var guard = 0;
        while (current != null && guard < RepositoryConstants.MAX_RECURSION_DEPTH) {
            if ((folder.getId() != null) && folder.getId().equals(current.getId())) {
                throw new IllegalArgumentException(msg(MessageKeys.ERROR_FOLDER_PARENT_DESCENDANT));
            }
            // Load parent manually for MyBatis
            if (current.getParentId() != null) {
                current = this.folderRepository.findById(current.getParentId());
            } else {
                current = null;
            }
            guard++;
        }
    }

    private FolderResponse toResponseWithPath(Folder folder) {
        final var base = this.folderMapper.toResponse(folder);
        final var path = buildPath(folder);
        final var level = Math.max(0, path.size() - 1);
        // Calculate subFolderCount from database since MyBatis doesn't load
        // relationships
        final var subFolderCount = (int) this.folderRepository.countByParentId(folder.getId());
        return base.toBuilder().path(path).level(level).subFolderCount(subFolderCount).build();
    }

    private List<String> buildPath(Folder folder) {
        final List<String> path = new ArrayList<>();
        var current = folder;
        var guard = 0;
        while ((current != null) && (guard < RepositoryConstants.MAX_RECURSION_DEPTH)) {
            path.add(current.getName());
            // Load parent manually for MyBatis
            if (current.getParentId() != null) {
                current = this.folderRepository.findById(current.getParentId());
            } else {
                current = null;
            }
            guard++;
        }
        Collections.reverse(path);
        return path;
    }
}
