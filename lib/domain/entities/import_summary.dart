import 'package:flash_mastery/domain/entities/import_error.dart';

class ImportSummary {
  final int successCount;
  final int decksCreated;
  final int decksSkipped;
  final List<String> skippedDeckNames;
  final int cardsImported;
  final int cardsSkippedDuplicate;
  final int invalidRows;
  final List<ImportError> errors;

  const ImportSummary({
    required this.successCount,
    required this.decksCreated,
    required this.decksSkipped,
    required this.skippedDeckNames,
    required this.cardsImported,
    required this.cardsSkippedDuplicate,
    required this.invalidRows,
    required this.errors,
  });
}
