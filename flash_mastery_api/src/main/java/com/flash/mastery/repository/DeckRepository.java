package com.flash.mastery.repository;

import com.flash.mastery.entity.Deck;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DeckRepository extends JpaRepository<Deck, UUID> {
  List<Deck> findByFolderId(UUID folderId);
}
