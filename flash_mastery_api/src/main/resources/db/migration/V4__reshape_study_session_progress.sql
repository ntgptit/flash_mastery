-- Recreate study_session_progress with normalized structure

DROP TABLE IF EXISTS study_session_progress;

CREATE TABLE IF NOT EXISTS study_session_progress (
    id UUID PRIMARY KEY,
    session_id UUID NOT NULL,
    flashcard_id UUID NOT NULL,
    overview_completed BOOLEAN NOT NULL DEFAULT FALSE,
    matching_completed BOOLEAN NOT NULL DEFAULT FALSE,
    guess_completed BOOLEAN NOT NULL DEFAULT FALSE,
    recall_completed BOOLEAN NOT NULL DEFAULT FALSE,
    fill_in_blank_completed BOOLEAN NOT NULL DEFAULT FALSE,
    correct_answers INTEGER NOT NULL DEFAULT 0,
    total_attempts INTEGER NOT NULL DEFAULT 0,
    last_studied_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_progress_session FOREIGN KEY (session_id) REFERENCES study_sessions(id) ON DELETE CASCADE,
    CONSTRAINT fk_progress_flashcard FOREIGN KEY (flashcard_id) REFERENCES flashcards(id) ON DELETE CASCADE,
    CONSTRAINT uk_session_flashcard UNIQUE (session_id, flashcard_id)
);

CREATE INDEX IF NOT EXISTS idx_progress_session_id ON study_session_progress(session_id);
CREATE INDEX IF NOT EXISTS idx_progress_flashcard_id ON study_session_progress(flashcard_id);
