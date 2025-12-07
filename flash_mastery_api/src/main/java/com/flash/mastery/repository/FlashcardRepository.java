package com.flash.mastery.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import com.flash.mastery.dto.criteria.FlashcardSearchCriteria;
import com.flash.mastery.entity.Flashcard;

public interface FlashcardRepository extends JpaRepository<Flashcard, UUID> {
    List<Flashcard> findByDeckId(UUID deckId);

    Page<Flashcard> findByDeckId(UUID deckId, Pageable pageable);

    /**
     * Find flashcards based on search criteria.
     */
    default List<Flashcard> findByCriteria(FlashcardSearchCriteria criteria) {
        if (!criteria.hasPagination()) {
            return findByDeckId(criteria.getDeckId());
        }

        final var pageable = PageRequest.of(
                criteria.getPage(),
                criteria.getSize(),
                Sort.by(Sort.Direction.DESC, "createdAt"));
        return findByDeckId(criteria.getDeckId(), pageable).getContent();
    }
}
