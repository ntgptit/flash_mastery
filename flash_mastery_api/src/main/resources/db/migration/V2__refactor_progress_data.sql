-- ====================================================================
-- V2__refactor_progress_data.sql
-- Refactor study_session_progress table to normalized structure
-- Replaces Map<UUID, String> with proper entity model
-- ====================================================================

-- Drop old table that used VARCHAR for progress data
DROP TABLE IF EXISTS flash_mastery.study_session_progress CASCADE;

-- Create new normalized table with full progress tracking
CREATE TABLE flash_mastery.study_session_progress (
    id UUID PRIMARY KEY,
    session_id UUID NOT NULL,
    flashcard_id UUID NOT NULL,
    mode VARCHAR(50) NOT NULL,
    completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP,
    correct_answers INT DEFAULT 0,
    total_attempts INT DEFAULT 0,
    last_studied_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    CONSTRAINT fk_study_session_progress_session
        FOREIGN KEY (session_id) REFERENCES flash_mastery.study_sessions(id) ON DELETE CASCADE,
    CONSTRAINT uq_study_session_progress_key
        UNIQUE (session_id, flashcard_id, mode)
);

-- Add indexes for query performance
CREATE INDEX idx_study_session_progress_session
    ON flash_mastery.study_session_progress(session_id);

CREATE INDEX idx_study_session_progress_flashcard
    ON flash_mastery.study_session_progress(session_id, flashcard_id);

CREATE INDEX idx_study_session_progress_mode
    ON flash_mastery.study_session_progress(mode);

CREATE INDEX idx_study_session_progress_completed
    ON flash_mastery.study_session_progress(session_id, completed);

-- Add comment for documentation
COMMENT ON TABLE flash_mastery.study_session_progress IS 'Tracks individual flashcard progress per study mode with accuracy metrics';
COMMENT ON COLUMN flash_mastery.study_session_progress.mode IS 'Study mode: OVERVIEW, MATCHING, GUESS, RECALL, FILL_IN_BLANK';
COMMENT ON COLUMN flash_mastery.study_session_progress.correct_answers IS 'Number of correct answers for this flashcard in this mode';
COMMENT ON COLUMN flash_mastery.study_session_progress.total_attempts IS 'Total number of attempts for this flashcard in this mode';
