-- Remove save session logic: delete completed_at column and SUCCESS/CANCEL status support
-- This migration removes all logic related to saving/completing study sessions

-- Step 1: Delete all sessions with SUCCESS or CANCEL status (they won't be needed anymore)
DELETE FROM flash_mastery.study_session_progress
WHERE session_id IN (
    SELECT id FROM flash_mastery.study_sessions
    WHERE status IN ('SUCCESS', 'CANCEL')
);

DELETE FROM flash_mastery.study_session_flashcard_ids
WHERE session_id IN (
    SELECT id FROM flash_mastery.study_sessions
    WHERE status IN ('SUCCESS', 'CANCEL')
);

DELETE FROM flash_mastery.study_sessions
WHERE status IN ('SUCCESS', 'CANCEL');

-- Step 2: Drop index on completed_at column
DROP INDEX IF EXISTS flash_mastery.idx_study_sessions_completed_at;

-- Step 3: Drop the check constraint that allows SUCCESS and CANCEL
ALTER TABLE flash_mastery.study_sessions
DROP CONSTRAINT IF EXISTS chk_study_sessions_status;

-- Step 4: Add new constraint that only allows IN_PROGRESS
ALTER TABLE flash_mastery.study_sessions
ADD CONSTRAINT chk_study_sessions_status
CHECK (status = 'IN_PROGRESS');

-- Step 5: Drop completed_at column
ALTER TABLE flash_mastery.study_sessions
DROP COLUMN IF EXISTS completed_at;

-- Step 6: Ensure all remaining sessions have IN_PROGRESS status
UPDATE flash_mastery.study_sessions
SET status = 'IN_PROGRESS'
WHERE status IS NULL OR status != 'IN_PROGRESS';

