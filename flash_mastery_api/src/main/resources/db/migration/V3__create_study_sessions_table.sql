-- Create study_sessions table
CREATE TABLE IF NOT EXISTS study_sessions (
    id UUID PRIMARY KEY,
    deck_id UUID NOT NULL,
    current_mode VARCHAR(32) NOT NULL DEFAULT 'OVERVIEW',
    current_batch_index INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'IN_PROGRESS',
    completed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_study_sessions_deck FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE,
    CONSTRAINT chk_study_sessions_status CHECK (status IN ('IN_PROGRESS', 'SUCCESS', 'CANCEL'))
);

-- Create study_session_flashcard_ids table (for ElementCollection)
CREATE TABLE IF NOT EXISTS study_session_flashcard_ids (
    session_id UUID NOT NULL,
    flashcard_id UUID NOT NULL,
    CONSTRAINT fk_study_session_flashcard_ids_session FOREIGN KEY (session_id) REFERENCES study_sessions(id) ON DELETE CASCADE,
    PRIMARY KEY (session_id, flashcard_id)
);

-- Create study_session_progress table (for ElementCollection Map)
CREATE TABLE IF NOT EXISTS study_session_progress (
    session_id UUID NOT NULL,
    flashcard_id UUID NOT NULL,
    progress_data VARCHAR(255),
    CONSTRAINT fk_study_session_progress_session FOREIGN KEY (session_id) REFERENCES study_sessions(id) ON DELETE CASCADE,
    PRIMARY KEY (session_id, flashcard_id)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_study_sessions_deck_id ON study_sessions(deck_id);
CREATE INDEX IF NOT EXISTS idx_study_sessions_completed_at ON study_sessions(completed_at);
CREATE INDEX IF NOT EXISTS idx_study_sessions_status ON study_sessions(status);

