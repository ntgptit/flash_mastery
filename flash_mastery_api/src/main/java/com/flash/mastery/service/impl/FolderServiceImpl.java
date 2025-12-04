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
  public List<FolderResponse> getFolders() {
    return folderRepository.findAll().stream().map(folderMapper::toResponse).toList();
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
    Folder saved = folderRepository.save(folder);
    return folderMapper.toResponse(saved);
  }

  @Override
  public FolderResponse update(UUID id, FolderUpdateRequest request) {
    Folder folder =
        folderRepository.findById(id).orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
    folderMapper.update(folder, request);
    Folder saved = folderRepository.save(folder);
    return folderMapper.toResponse(saved);
  }

  @Override
  public void delete(UUID id) {
    Folder folder =
        folderRepository.findById(id).orElseThrow(() -> new NotFoundException(msg(MessageKeys.ERROR_NOT_FOUND_FOLDER)));
    folderRepository.delete(folder);
  }

  private String msg(String key) {
    return messageSource.getMessage(key, null, LocaleContextHolder.getLocale());
  }
}
