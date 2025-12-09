package com.flash.mastery.dto.criteria;

import java.util.UUID;

import lombok.Builder;
import lombok.Value;

/**
 * Search criteria for flashcard queries.
 */
@Value
@Builder
public class FlashcardSearchCriteria {
    UUID deckId;
    Integer page;
    Integer size;

    /**
     * Check if deck filter is applied.
     */
    public boolean hasDeckFilter() {
        return deckId != null;
    }

    /**
     * Check if pagination is requested.
     */
    public boolean hasPagination() {
        return (page != null) && (size != null) && (size > 0);
    }
}


