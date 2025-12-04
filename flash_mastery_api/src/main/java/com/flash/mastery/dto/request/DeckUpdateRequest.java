package com.flash.mastery.dto.request;

import com.flash.mastery.constant.ValidationConstants;
import jakarta.validation.constraints.Size;
import java.util.UUID;
import lombok.Data;

@Data
public class DeckUpdateRequest {
  @Size(max = ValidationConstants.NAME_MAX_LENGTH)
  private String name;
  private String description;
  private UUID folderId;
}
