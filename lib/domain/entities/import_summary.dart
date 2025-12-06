import 'package:flash_mastery/domain/entities/import_error.dart';

class ImportSummary {
  final int successCount;
  final List<ImportError> errors;

  const ImportSummary({required this.successCount, required this.errors});
}
