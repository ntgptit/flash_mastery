package com.flash.mastery.dto.request;

import com.flash.mastery.constant.ValidationConstants;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class FolderUpdateRequest {
  @Size(max = ValidationConstants.NAME_MAX_LENGTH)
  private String name;
  private String description;
  @Size(max = ValidationConstants.COLOR_MAX_LENGTH)
  private String color;
}
