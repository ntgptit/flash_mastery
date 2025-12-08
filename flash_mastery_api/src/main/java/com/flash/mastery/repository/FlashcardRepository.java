package com.flash.mastery.repository;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.flash.mastery.constant.RepositoryConstants;
import com.flash.mastery.entity.Flashcard;

@Mapper
public interface FlashcardRepository {

    Flashcard findById(@Param(RepositoryConstants.PARAM_ID) UUID id);

    List<Flashcard> findByDeckId(@Param(RepositoryConstants.PARAM_DECK_ID) UUID deckId);

    List<Flashcard> findByDeckIdWithPagination(@Param(RepositoryConstants.PARAM_DECK_ID) UUID deckId,
            @Param(RepositoryConstants.PARAM_OFFSET) int offset,
            @Param(RepositoryConstants.PARAM_LIMIT) int limit);

    List<Flashcard> findByIdIn(@Param(RepositoryConstants.PARAM_IDS) List<UUID> ids);

    void insert(Flashcard flashcard);

    void update(Flashcard flashcard);

    void deleteById(@Param(RepositoryConstants.PARAM_ID) UUID id);

    void deleteByDeckId(@Param(RepositoryConstants.PARAM_DECK_ID) UUID deckId);

    long countByDeckId(@Param(RepositoryConstants.PARAM_DECK_ID) UUID deckId);
}
