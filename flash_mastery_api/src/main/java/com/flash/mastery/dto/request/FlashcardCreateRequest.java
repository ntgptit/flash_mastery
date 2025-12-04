package com.flash.mastery.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.util.UUID;
import lombok.Data;

@Data
public class FlashcardCreateRequest {
  @NotNull
  private UUID deckId;

  @NotBlank
  private String question;

  @NotBlank
  private String answer;

  private String hint;
}
