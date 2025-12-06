package com.flash.mastery.util.importer;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class ImportError {
    private int rowIndex;
    private String message;
}
