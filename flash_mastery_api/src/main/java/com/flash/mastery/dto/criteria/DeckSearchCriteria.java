package com.flash.mastery.dto.criteria;

import java.util.UUID;

import lombok.Builder;
import lombok.Value;

/**
 * Search criteria for deck queries.
 */
@Value
@Builder
public class DeckSearchCriteria {
    UUID folderId;
    String query;

    /**
     * Check if folder filter is applied.
     */
    public boolean hasFolderFilter() {
        return folderId != null;
    }

    /**
     * Check if query filter is applied.
     */
    public boolean hasQueryFilter() {
        return (query != null) && !query.isBlank();
    }

    /**
     * Check if any filter is applied.
     */
    public boolean hasAnyFilter() {
        return hasFolderFilter() || hasQueryFilter();
    }
}

