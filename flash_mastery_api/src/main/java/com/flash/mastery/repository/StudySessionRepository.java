package com.flash.mastery.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.flash.mastery.entity.StudySession;

public interface StudySessionRepository extends JpaRepository<StudySession, UUID> {
    List<StudySession> findByDeckId(UUID deckId);
}

