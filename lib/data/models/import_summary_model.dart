import 'package:flash_mastery/data/models/import_error_model.dart';
import 'package:flash_mastery/domain/entities/import_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_summary_model.freezed.dart';
part 'import_summary_model.g.dart';

@freezed
abstract class ImportSummaryModel with _$ImportSummaryModel {
  const ImportSummaryModel._();

  const factory ImportSummaryModel({
    @Default(0) int successCount,
    @Default(0) int decksCreated,
    @Default(0) int decksSkipped,
    @Default(<String>[]) List<String> skippedDeckNames,
    @Default(0) int cardsImported,
    @Default(0) int cardsSkippedDuplicate,
    @Default(0) int invalidRows,
    @Default(<ImportErrorModel>[]) List<ImportErrorModel> errors,
  }) = _ImportSummaryModel;

  factory ImportSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ImportSummaryModelFromJson(json);

  ImportSummary toEntity() =>
      ImportSummary(
        successCount: successCount,
        decksCreated: decksCreated,
        decksSkipped: decksSkipped,
        skippedDeckNames: skippedDeckNames,
        cardsImported: cardsImported,
        cardsSkippedDuplicate: cardsSkippedDuplicate,
        invalidRows: invalidRows,
        errors: errors.map((e) => e.toEntity()).toList(),
      );
}
