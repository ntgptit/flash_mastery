package com.flash.mastery.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "flashcards")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Flashcard extends BaseAuditEntity {

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "deck_id", nullable = false)
  @ToString.Exclude
  private Deck deck;

  @Column(name = "question", nullable = false)
  private String question;

  @Column(name = "answer", nullable = false)
  private String answer;

  @Column(name = "hint")
  private String hint;

  @Enumerated(EnumType.STRING)
  @Column(name = "type", nullable = true, length = 32)
  private FlashcardType type;
}
