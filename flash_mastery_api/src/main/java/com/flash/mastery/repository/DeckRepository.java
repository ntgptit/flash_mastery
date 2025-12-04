package com.flash.mastery.repository;

import com.flash.mastery.entity.Deck;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DeckRepository extends JpaRepository<Deck, UUID> {
  Page<Deck> findByFolderId(UUID folderId, Pageable pageable);

  Page<Deck> findByNameContainingIgnoreCase(String name, Pageable pageable);

  Page<Deck> findByFolderIdAndNameContainingIgnoreCase(UUID folderId, String name, Pageable pageable);
}
