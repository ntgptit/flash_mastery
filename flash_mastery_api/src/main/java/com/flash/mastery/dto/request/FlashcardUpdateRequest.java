package com.flash.mastery.dto.request;

import com.flash.mastery.entity.FlashcardType;

import lombok.Data;

@Data
public class FlashcardUpdateRequest {
    private String question;
    private String answer;
    private String hint;
    private FlashcardType type;
}
