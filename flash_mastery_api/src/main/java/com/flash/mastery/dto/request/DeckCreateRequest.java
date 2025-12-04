package com.flash.mastery.dto.request;

import com.flash.mastery.constant.ValidationConstants;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.UUID;
import lombok.Data;

@Data
public class DeckCreateRequest {
  @NotBlank
  @Size(max = ValidationConstants.NAME_MAX_LENGTH)
  private String name;
  private String description;

  @NotNull
  private UUID folderId;
}
