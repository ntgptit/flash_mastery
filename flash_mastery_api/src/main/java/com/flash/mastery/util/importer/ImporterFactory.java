package com.flash.mastery.util.importer;

import java.util.Locale;

import com.flash.mastery.util.importer.csv.CsvImporter;
import com.flash.mastery.util.importer.excel.ExcelImporter;

public class ImporterFactory {

    public static <T> Importer<T> forFilename(String filename) {
        String lower = filename.toLowerCase(Locale.ROOT);
        if (lower.endsWith(".csv") || lower.endsWith(".tsv")) {
            return new CsvImporter<>();
        }
        if (lower.endsWith(".xlsx")) {
            return new ExcelImporter<>();
        }
        throw new IllegalArgumentException("Unsupported file type: " + filename);
    }
}
