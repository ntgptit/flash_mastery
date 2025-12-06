-- Add deck type column (nullable to avoid failures with existing data) and seed defaults
ALTER TABLE IF EXISTS flash_mastery.decks
  ADD COLUMN IF NOT EXISTS type varchar(32);

UPDATE flash_mastery.decks
SET type = 'VOCABULARY'
WHERE type IS NULL;
