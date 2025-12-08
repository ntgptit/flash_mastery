package com.flash.mastery.entity;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import com.flash.mastery.entity.enums.FlashcardType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Deck extends BaseAuditEntity {

    private String name;
    private String description;
    private int cardCount;

    @Default
    private FlashcardType type = FlashcardType.VOCABULARY;

    private UUID folderId;

    @ToString.Exclude
    private Folder folder;

    @ToString.Exclude
    @Default
    private Set<Flashcard> flashcards = new HashSet<>();
}
