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

    public void addItem(T item) {
        if (item != null) {
            items.add(item);
        }
    }

    public void addError(int rowIndex, String message) {
        errors.add(ImportError.builder().rowIndex(rowIndex).message(message).build());
    }
}
