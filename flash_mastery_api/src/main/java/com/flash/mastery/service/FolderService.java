package com.flash.mastery.service;

import com.flash.mastery.dto.request.FolderCreateRequest;
import com.flash.mastery.dto.request.FolderUpdateRequest;
import com.flash.mastery.dto.response.FolderResponse;
import java.util.List;
import java.util.UUID;

public interface FolderService {
  List<FolderResponse> getFolders(UUID parentId);
  FolderResponse getFolder(UUID id);
  FolderResponse create(FolderCreateRequest request);
  FolderResponse update(UUID id, FolderUpdateRequest request);
  void delete(UUID id);
}
