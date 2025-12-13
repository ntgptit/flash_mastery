package com.flash.mastery.dto.criteria;

import java.util.UUID;

import lombok.Builder;
import lombok.Value;

/**
 * Search criteria for folder queries.
 */
@Value
@Builder
public class FolderSearchCriteria {
    UUID parentId;

    /**
     * Check if parent filter is applied.
     */
    public boolean hasParentFilter() {
        return parentId != null;
    }

    /**
     * Check if root folders should be returned (no parent filter).
     */
    public boolean isRootFolders() {
        return parentId == null;
    }
}


