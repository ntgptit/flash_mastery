package com.flash.mastery.controller;

import com.flash.mastery.dto.request.FolderCreateRequest;
import com.flash.mastery.dto.request.FolderUpdateRequest;
import com.flash.mastery.dto.response.FolderResponse;
import com.flash.mastery.service.FolderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/folders")
@RequiredArgsConstructor
@Tag(name = "Folders", description = "Manage folders")
public class FolderController {

  private final FolderService folderService;

  @GetMapping
  @Operation(summary = "List folders", responses = @ApiResponse(responseCode = "200", description = "List of folders"))
  public List<FolderResponse> list(@RequestParam(value = "parentId", required = false) UUID parentId) {
    return folderService.getFolders(parentId);
  }

  @GetMapping("/{id}")
  @Operation(
      summary = "Get folder detail",
      responses = {
        @ApiResponse(responseCode = "200", description = "Folder found"),
        @ApiResponse(responseCode = "404", description = "Folder not found", content = @Content(schema = @Schema(hidden = true)))
      })
  public FolderResponse get(@PathVariable UUID id) {
    return folderService.getFolder(id);
  }

  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  @Operation(summary = "Create folder", responses = @ApiResponse(responseCode = "201", description = "Folder created"))
  public FolderResponse create(@Valid @RequestBody FolderCreateRequest request) {
    return folderService.create(request);
  }

  @PutMapping("/{id}")
  @Operation(
      summary = "Update folder",
      responses = {
        @ApiResponse(responseCode = "200", description = "Folder updated"),
        @ApiResponse(responseCode = "404", description = "Folder not found", content = @Content(schema = @Schema(hidden = true)))
      })
  public FolderResponse update(@PathVariable UUID id, @Valid @RequestBody FolderUpdateRequest request) {
    return folderService.update(id, request);
  }

  @DeleteMapping("/{id}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  @Operation(
      summary = "Delete folder",
      responses = {
        @ApiResponse(responseCode = "204", description = "Folder deleted"),
        @ApiResponse(responseCode = "404", description = "Folder not found", content = @Content(schema = @Schema(hidden = true)))
      })
  public void delete(@PathVariable UUID id) {
    folderService.delete(id);
  }
}
