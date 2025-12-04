package com.flash.mastery.repository;

import com.flash.mastery.entity.Flashcard;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FlashcardRepository extends JpaRepository<Flashcard, UUID> {
  List<Flashcard> findByDeckId(UUID deckId);
}
