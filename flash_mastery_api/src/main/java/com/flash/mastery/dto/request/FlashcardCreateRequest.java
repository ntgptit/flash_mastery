package com.flash.mastery.dto.request;

import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.flash.mastery.entity.enums.FlashcardType;

import jakarta.validation.constraints.NotBlank;
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
