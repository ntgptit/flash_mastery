-- Update existing flashcards with null type to have default VOCABULARY type
UPDATE flash_mastery.flashcards
SET type = 'VOCABULARY'
WHERE type IS NULL;
