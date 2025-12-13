-- Add next_mode column to persist the upcoming study mode after the current one
ALTER TABLE study_sessions
    ADD COLUMN IF NOT EXISTS next_mode VARCHAR(32);

-- Backfill existing rows based on current_mode so resuming a session knows what comes next
UPDATE study_sessions
SET next_mode = CASE current_mode
    WHEN 'OVERVIEW' THEN 'MATCHING'
    WHEN 'MATCHING' THEN 'GUESS'
    WHEN 'GUESS' THEN 'RECALL'
    WHEN 'RECALL' THEN 'FILL_IN_BLANK'
    ELSE NULL
END
WHERE next_mode IS NULL;

-- Keep values constrained to the enum set while still allowing NULL for terminal states
ALTER TABLE study_sessions
    ADD CONSTRAINT chk_study_sessions_next_mode
    CHECK (next_mode IN ('OVERVIEW', 'MATCHING', 'GUESS', 'RECALL', 'FILL_IN_BLANK') OR next_mode IS NULL);
