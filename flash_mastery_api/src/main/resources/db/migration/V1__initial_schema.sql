-- =====================================================
-- Flash Mastery Database Schema
-- Version: 1.0.0
-- Description: Initial database schema with all tables
-- =====================================================

-- Create flash_mastery schema if not exists
CREATE SCHEMA IF NOT EXISTS flash_mastery;

-- Enable UUID extension if not exists
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLE: folders
-- Description: Stores folder structure for organizing decks
-- =====================================================
CREATE TABLE IF NOT EXISTS folders (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    color VARCHAR(32),
    deck_count INTEGER NOT NULL DEFAULT 0,
    parent_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    CONSTRAINT fk_folders_parent FOREIGN KEY (parent_id) REFERENCES folders(id) ON DELETE CASCADE
);

-- =====================================================
-- TABLE: decks
-- Description: Stores flashcard decks
-- =====================================================
CREATE TABLE IF NOT EXISTS decks (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    card_count INTEGER NOT NULL DEFAULT 0,
    type VARCHAR(32) NOT NULL DEFAULT 'VOCABULARY',
    folder_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    CONSTRAINT fk_decks_folder FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE SET NULL
);

-- =====================================================
-- TABLE: flashcards
-- Description: Stores individual flashcards
-- =====================================================
CREATE TABLE IF NOT EXISTS flashcards (
    id UUID PRIMARY KEY,
    deck_id UUID NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    hint TEXT,
    type VARCHAR(32) NOT NULL DEFAULT 'VOCABULARY',
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    CONSTRAINT fk_flashcards_deck FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE
);

-- =====================================================
-- TABLE: study_sessions
-- Description: Stores active study sessions
-- =====================================================
CREATE TABLE IF NOT EXISTS study_sessions (
    id UUID PRIMARY KEY,
    deck_id UUID NOT NULL,
    current_mode VARCHAR(32) NOT NULL DEFAULT 'OVERVIEW',
    current_batch_index INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'IN_PROGRESS',
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    CONSTRAINT fk_study_sessions_deck FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE,
    CONSTRAINT chk_study_sessions_status CHECK (status = 'IN_PROGRESS')
);

-- =====================================================
-- TABLE: study_session_flashcard_ids
-- Description: Stores flashcard IDs for each study session (ElementCollection)
-- =====================================================
CREATE TABLE IF NOT EXISTS study_session_flashcard_ids (
    session_id UUID NOT NULL,
    flashcard_id UUID NOT NULL,
    CONSTRAINT fk_study_session_flashcard_ids_session FOREIGN KEY (session_id) REFERENCES study_sessions(id) ON DELETE CASCADE,
    PRIMARY KEY (session_id, flashcard_id)
);

-- =====================================================
-- TABLE: study_session_progress
-- Description: Stores progress data for each flashcard in a study session (ElementCollection Map)
-- =====================================================
CREATE TABLE IF NOT EXISTS study_session_progress (
    session_id UUID NOT NULL,
    flashcard_id UUID NOT NULL,
    progress_data VARCHAR(255),
    CONSTRAINT fk_study_session_progress_session FOREIGN KEY (session_id) REFERENCES study_sessions(id) ON DELETE CASCADE,
    PRIMARY KEY (session_id, flashcard_id)
);

-- =====================================================
-- INDEXES: Performance optimization indexes
-- =====================================================

-- Folder indexes
CREATE INDEX IF NOT EXISTS idx_folders_parent_id ON folders(parent_id);
CREATE INDEX IF NOT EXISTS idx_folders_deleted_at ON folders(deleted_at);

-- Deck indexes
CREATE INDEX IF NOT EXISTS idx_decks_folder_id ON decks(folder_id);
CREATE INDEX IF NOT EXISTS idx_decks_deleted_at ON decks(deleted_at);

-- Flashcard indexes
CREATE INDEX IF NOT EXISTS idx_flashcards_deck_id ON flashcards(deck_id);
CREATE INDEX IF NOT EXISTS idx_flashcards_deleted_at ON flashcards(deleted_at);

-- Study session indexes
CREATE INDEX IF NOT EXISTS idx_study_sessions_deck_id ON study_sessions(deck_id);
CREATE INDEX IF NOT EXISTS idx_study_sessions_status ON study_sessions(status);
CREATE INDEX IF NOT EXISTS idx_study_sessions_deleted_at ON study_sessions(deleted_at);

-- =====================================================
-- COMMENTS: Add table and column comments for documentation
-- =====================================================

COMMENT ON TABLE folders IS 'Stores folder structure for organizing decks hierarchically';
COMMENT ON TABLE decks IS 'Stores flashcard decks with metadata';
COMMENT ON TABLE flashcards IS 'Stores individual flashcards with question-answer pairs';
COMMENT ON TABLE study_sessions IS 'Stores active study sessions (only IN_PROGRESS sessions are kept)';
COMMENT ON TABLE study_session_flashcard_ids IS 'Junction table for study session flashcard relationships';
COMMENT ON TABLE study_session_progress IS 'Stores progress tracking data for each flashcard in a session';

COMMENT ON COLUMN folders.deck_count IS 'Cached count of decks in this folder';
COMMENT ON COLUMN folders.parent_id IS 'Parent folder ID for hierarchical structure';
COMMENT ON COLUMN decks.card_count IS 'Cached count of flashcards in this deck';
COMMENT ON COLUMN decks.type IS 'Type of flashcards in this deck (e.g., VOCABULARY)';
COMMENT ON COLUMN flashcards.hint IS 'Optional hint to help answer the question';
COMMENT ON COLUMN study_sessions.current_mode IS 'Current study mode: OVERVIEW, MATCHING, GUESS, RECALL, FILL_IN_BLANK';
COMMENT ON COLUMN study_sessions.current_batch_index IS 'Current batch index (batch size = 7 flashcards)';
COMMENT ON COLUMN study_sessions.status IS 'Session status (only IN_PROGRESS is allowed)';

-- =====================================================
-- END OF MIGRATION
-- =====================================================
