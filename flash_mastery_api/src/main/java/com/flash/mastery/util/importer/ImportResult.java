package com.flash.mastery.util.importer;

import java.util.ArrayList;
import java.util.List;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ImportResult<T> {
    @Builder.Default
    private List<T> items = new ArrayList<>();
    @Builder.Default
    private List<ImportError> errors = new ArrayList<>();
    @Builder.Default
    private int decksCreated = 0;
    @Builder.Default
    private int decksSkipped = 0;
    @Builder.Default
    private List<String> skippedDeckNames = new ArrayList<>();
    @Builder.Default
    private int cardsImported = 0;
    @Builder.Default
    private int cardsSkippedDuplicate = 0;
    @Builder.Default
    private int invalidRows = 0;

    public void addItem(T item) {
        if (item != null) {
            items.add(item);
        }
    }

    public void addError(int rowIndex, String message) {
        errors.add(ImportError.builder().rowIndex(rowIndex).message(message).build());
        invalidRows++;
    }

    public void addDeckCreated() {
        decksCreated++;
    }

    public void addDeckSkipped(String name, int rowIndex) {
        decksSkipped++;
        if (name != null) {
            skippedDeckNames.add(name);
        }
        addError(rowIndex, "Duplicate deck name: " + name);
    }

    public void addCardImported() {
        cardsImported++;
    }

    public void addCardDuplicate(int rowIndex, String term, String deckName) {
        cardsSkippedDuplicate++;
        addError(rowIndex, "Duplicate term '" + term + "' in deck '" + deckName + "'");
    }

    public void addInvalidRow(int rowIndex, String message) {
        addError(rowIndex, message);
    }
}
