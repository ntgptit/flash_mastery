package com.flash.mastery.util.importer;

import java.util.List;

public record RowContext(int rowIndex, List<String> cells) {
    public String cell(int index) {
        return index < 0 || index >= cells.size() ? null : cells.get(index);
    }
}
