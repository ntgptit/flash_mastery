import 'package:flash_mastery/domain/entities/import_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_error_model.freezed.dart';
part 'import_error_model.g.dart';

@freezed
abstract class ImportErrorModel with _$ImportErrorModel {
  const ImportErrorModel._();

  const factory ImportErrorModel({@Default(0) int rowIndex, @Default('') String message}) =
      _ImportErrorModel;

  factory ImportErrorModel.fromJson(Map<String, dynamic> json) => _$ImportErrorModelFromJson(json);

  ImportError toEntity() => ImportError(rowIndex: rowIndex, message: message);
}
