package com.flash.mastery.util.importer;

import java.io.IOException;
import java.io.InputStream;
import java.util.function.Function;

public interface Importer<C extends RowContext, T> {
    ImportResult<T> importStream(InputStream inputStream, Function<C, T> mapper) throws IOException;
}
