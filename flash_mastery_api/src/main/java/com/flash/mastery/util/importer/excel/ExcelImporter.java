package com.flash.mastery.util.importer.excel;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.flash.mastery.util.importer.Importer;
import com.flash.mastery.util.importer.ImportResult;
import com.flash.mastery.util.importer.RowContext;

public class ExcelImporter<T> implements Importer<T> {

    @Override
    public ImportResult<T> importStream(InputStream inputStream, Function<RowContext, ? extends T> mapper, boolean skipFirstRow) throws IOException {
        var result = ImportResult.<T>builder().build();
        try (XSSFWorkbook workbook = new XSSFWorkbook(inputStream)) {
            Sheet sheet = workbook.getNumberOfSheets() > 0 ? workbook.getSheetAt(0) : null;
            if (sheet == null) {
                return result;
            }
            int rowIndex = 0;
            for (Row row : sheet) {
                rowIndex++;
                if (skipFirstRow && rowIndex == 1) {
                    continue;
                }
                List<String> cells = new ArrayList<>();
                for (int i = 0; i < row.getLastCellNum(); i++) {
                    Cell cell = row.getCell(i);
                    cells.add(cell != null ? cell.toString() : "");
                }
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
