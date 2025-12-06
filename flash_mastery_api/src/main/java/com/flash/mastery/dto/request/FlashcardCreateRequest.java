package com.flash.mastery.dto.request;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.validation.constraints.NotBlank;
import java.util.UUID;
import com.flash.mastery.entity.FlashcardType;
import lombok.Data;

@Data
public class FlashcardCreateRequest {
  @JsonIgnore
  private UUID deckId;

  @NotBlank
  private String question;

  @NotBlank
  private String answer;

  private String hint;

  private FlashcardType type;
}
