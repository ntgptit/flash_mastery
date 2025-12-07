-- Create decks table
CREATE TABLE IF NOT EXISTS decks (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    card_count INTEGER NOT NULL DEFAULT 0,
    type VARCHAR(32),
    folder_id UUID,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_decks_folder FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE SET NULL
);

-- Create flashcards table
CREATE TABLE IF NOT EXISTS flashcards (
    id UUID PRIMARY KEY,
    deck_id UUID NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    hint TEXT,
    type VARCHAR(32),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_flashcards_deck FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_decks_folder_id ON decks(folder_id);
CREATE INDEX IF NOT EXISTS idx_flashcards_deck_id ON flashcards(deck_id);

