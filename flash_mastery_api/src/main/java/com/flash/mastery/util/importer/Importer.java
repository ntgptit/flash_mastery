package com.flash.mastery.util.importer;

import java.io.IOException;
import java.io.InputStream;
import java.util.function.Function;

public interface Importer<T> {
    ImportResult<T> importStream(InputStream inputStream, Function<RowContext, ? extends T> mapper) throws IOException;
}
