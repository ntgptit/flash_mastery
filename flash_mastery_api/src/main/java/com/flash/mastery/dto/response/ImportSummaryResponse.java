package com.flash.mastery.dto.response;

import java.util.List;
import com.flash.mastery.util.importer.ImportError;
import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class ImportSummaryResponse {
    int successCount;
    List<ImportError> errors;
}
