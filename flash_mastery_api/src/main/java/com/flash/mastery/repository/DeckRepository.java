package com.flash.mastery.repository;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.flash.mastery.dto.criteria.DeckSearchCriteria;
import com.flash.mastery.entity.Deck;

public interface DeckRepository extends JpaRepository<Deck, UUID> {
    Page<Deck> findByFolderId(UUID folderId, Pageable pageable);

    Page<Deck> findByNameContainingIgnoreCase(String name, Pageable pageable);

    Page<Deck> findByFolderIdAndNameContainingIgnoreCase(UUID folderId, String name, Pageable pageable);

    boolean existsByFolderIdAndNameIgnoreCase(UUID folderId, String name);

    /**
     * Find decks based on search criteria.
     */
    default Page<Deck> findByCriteria(DeckSearchCriteria criteria, Pageable pageable) {
        if (!criteria.hasAnyFilter()) {
            return findAll(pageable);
        }

        if (criteria.hasFolderFilter() && criteria.hasQueryFilter()) {
            return findByFolderIdAndNameContainingIgnoreCase(
                    criteria.getFolderId(),
                    criteria.getQuery(),
                    pageable);
        }

        if (criteria.hasFolderFilter()) {
            return findByFolderId(criteria.getFolderId(), pageable);
        }

        if (criteria.hasQueryFilter()) {
            return findByNameContainingIgnoreCase(criteria.getQuery(), pageable);
        }

        return findAll(pageable);
    }
}
