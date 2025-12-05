package com.flash.mastery.service.impl;

import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.dto.request.FolderCreateRequest;
import com.flash.mastery.dto.request.FolderUpdateRequest;
import com.flash.mastery.dto.response.FolderResponse;
import com.flash.mastery.entity.Folder;
import com.flash.mastery.exception.NotFoundException;
import com.flash.mastery.mapper.FolderMapper;
import com.flash.mastery.repository.FolderRepository;
import com.flash.mastery.service.FolderService;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    if (parentId == null) {
      return folderRepository.findAll().stream().map(folderMapper::toResponse).toList();
    }
    folderRepository
        .findById(parentId)
        .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
    return folderRepository.findByParentId(parentId).stream().map(folderMapper::toResponse).toList();
  }

  @Override
  @Transactional(readOnly = true)
  public FolderResponse getFolder(UUID id) {
    Folder folder =
        folderRepository.findById(id).orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
    return folderMapper.toResponse(folder);
  }

  @Override
  public FolderResponse create(FolderCreateRequest request) {
    Folder folder = folderMapper.fromCreate(request);
    if (request.getParentId() != null) {
      Folder parent =
          folderRepository
              .findById(request.getParentId())
              .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
      folder.setParent(parent);
    }
    Folder saved = folderRepository.save(folder);
    return folderMapper.toResponse(saved);
  }

  @Override
  public FolderResponse update(UUID id, FolderUpdateRequest request) {
    Folder folder =
        folderRepository.findById(id).orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
    if (request.getParentId() != null) {
      if (id.equals(request.getParentId())) {
        throw new IllegalArgumentException("Folder cannot reference itself as parent");
      }
      Folder parent =
          folderRepository
              .findById(request.getParentId())
              .orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
      validateParent(folder, parent);
      folder.setParent(parent);
    }
    folderMapper.update(folder, request);
    Folder saved = folderRepository.save(folder);
    return folderMapper.toResponse(saved);
  }

  @Override
  public void delete(UUID id) {
    Folder folder =
        folderRepository.findById(id).orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
    if (!folder.getChildren().isEmpty()) {
      throw new IllegalArgumentException("Cannot delete a folder that contains subfolders");
    }
    folderRepository.delete(folder);
  }

  private String msg(String key) {
    return messageSource.getMessage(key, null, LocaleContextHolder.getLocale());
  }

  private void validateParent(Folder folder, Folder newParent) {
    Folder current = newParent;
    while (current != null) {
      if (folder.getId() != null && folder.getId().equals(current.getId())) {
        throw new IllegalArgumentException("Parent folder cannot be a descendant of the folder");
      }
      current = current.getParent();
    }
  }
}
