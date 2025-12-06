package com.flash.mastery.dto.response;

import java.util.List;
import com.flash.mastery.util.importer.ImportError;
import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class ImportSummaryResponse {
    int successCount;
    int decksCreated;
    int decksSkipped;
    List<String> skippedDeckNames;
    int cardsImported;
    int cardsSkippedDuplicate;
    int invalidRows;
    List<ImportError> errors;
}
