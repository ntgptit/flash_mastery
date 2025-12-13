-- Align status check constraint with allowed enum values

ALTER TABLE study_sessions
    DROP CONSTRAINT IF EXISTS chk_study_sessions_status;

ALTER TABLE study_sessions
    ADD CONSTRAINT chk_study_sessions_status
        CHECK (status IN ('IN_PROGRESS', 'SUCCESS', 'CANCEL'));
