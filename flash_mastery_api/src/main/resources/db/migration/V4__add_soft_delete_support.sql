-- Add deleted_at column for soft delete support to all tables

ALTER TABLE flash_mastery.folders ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL;
ALTER TABLE flash_mastery.decks ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL;
ALTER TABLE flash_mastery.flashcards ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL;
ALTER TABLE flash_mastery.study_sessions ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL;

-- Create indexes for better query performance on deleted_at
CREATE INDEX IF NOT EXISTS idx_folders_deleted_at ON flash_mastery.folders(deleted_at);
CREATE INDEX IF NOT EXISTS idx_decks_deleted_at ON flash_mastery.decks(deleted_at);
CREATE INDEX IF NOT EXISTS idx_flashcards_deleted_at ON flash_mastery.flashcards(deleted_at);
CREATE INDEX IF NOT EXISTS idx_study_sessions_deleted_at ON flash_mastery.study_sessions(deleted_at);

