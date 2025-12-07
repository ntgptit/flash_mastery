package com.flash.mastery.dto.request;

import java.util.List;
import java.util.UUID;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class StudySessionCreateRequest {
    @NotNull
    private UUID deckId;

    private List<UUID> flashcardIds; // Optional: if null, use all flashcards from deck
}

