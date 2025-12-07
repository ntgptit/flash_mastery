package com.flash.mastery.repository;

import com.flash.mastery.entity.Folder;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

import com.flash.mastery.dto.criteria.FolderSearchCriteria;

public interface FolderRepository extends JpaRepository<Folder, UUID> {
    List<Folder> findByParentId(UUID parentId);

    List<Folder> findByParentIsNull();

    /**
     * Find folders based on search criteria.
     */
    default List<Folder> findByCriteria(FolderSearchCriteria criteria) {
        if (criteria.isRootFolders()) {
            return findByParentIsNull();
        }

        if (criteria.hasParentFilter()) {
            return findByParentId(criteria.getParentId());
        }

        return findByParentIsNull();
    }
}
