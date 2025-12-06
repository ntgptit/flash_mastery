package com.flash.mastery.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.flash.mastery.entity.Flashcard;

public interface FlashcardRepository extends JpaRepository<Flashcard, UUID> {
    List<Flashcard> findByDeckId(UUID deckId);
    Page<Flashcard> findByDeckId(UUID deckId, Pageable pageable);
}
