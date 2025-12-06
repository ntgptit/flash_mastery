package com.flash.mastery.util.importer.csv;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import com.flash.mastery.util.importer.Importer;
import com.flash.mastery.util.importer.ImportResult;
import com.flash.mastery.util.importer.RowContext;

public class CsvImporter<T> implements Importer<T> {

    private final CSVFormat format;

    public CsvImporter() {
        this.format = CSVFormat.DEFAULT
                .builder()
                .setSkipHeaderRecord(true)
                .setIgnoreSurroundingSpaces(true)
                .setIgnoreHeaderCase(true)
                .setTrim(true)
                .setAllowMissingColumnNames(true)
                .build();
    }

    @Override
    public ImportResult<T> importStream(InputStream inputStream, Function<RowContext, T> mapper) throws IOException {
        var result = ImportResult.<T>builder().build();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8));
             CSVParser parser = new CSVParser(reader, format)) {
            int rowIndex = 0;
            for (CSVRecord csvRecord : parser) {
                rowIndex++;
                List<String> cells = new ArrayList<>();
                csvRecord.forEach(cells::add);
                var ctx = new RowContext(rowIndex, cells);
                try {
                    T mapped = mapper.apply(ctx);
                    if (mapped != null) {
                        result.addItem(mapped);
                    }
                } catch (Exception ex) {
                    result.addError(rowIndex, ex.getMessage());
                }
            }
        }
        return result;
    }
}
