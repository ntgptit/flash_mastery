package com.flash.mastery.dto.request;

import lombok.Data;

@Data
public class FlashcardUpdateRequest {
  private String question;
  private String answer;
  private String hint;
}
