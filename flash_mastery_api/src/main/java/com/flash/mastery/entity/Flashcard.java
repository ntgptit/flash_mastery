package com.flash.mastery.entity;

import java.util.UUID;

import com.flash.mastery.entity.enums.FlashcardType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Flashcard extends BaseAuditEntity {

  private UUID deckId;

  @ToString.Exclude
  private Deck deck;

  private String question;
  private String answer;
  private String hint;
  private FlashcardType type;
}
