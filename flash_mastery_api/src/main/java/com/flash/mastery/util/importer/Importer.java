package com.flash.mastery.util.importer;

import java.io.IOException;
import java.io.InputStream;
import java.util.function.Function;

public interface Importer<T> {
    default ImportResult<T> importStream(InputStream inputStream, Function<RowContext, ? extends T> mapper) throws IOException {
        return importStream(inputStream, mapper, false);
    }

    ImportResult<T> importStream(InputStream inputStream, Function<RowContext, ? extends T> mapper, boolean skipFirstRow) throws IOException;
}
