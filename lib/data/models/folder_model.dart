import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/folder.dart';

part 'folder_model.freezed.dart';
part 'folder_model.g.dart';

@freezed
abstract class FolderModel with _$FolderModel {
  const FolderModel._();

  const factory FolderModel({
    required String id,
    required String name,
    String? description,
    String? color,
    @Default(0) int deckCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FolderModel;

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);

  /// Convert model to entity
  Folder toEntity() {
    return Folder(
      id: id,
      name: name,
      description: description,
      color: color,
      deckCount: deckCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create model from entity
  factory FolderModel.fromEntity(Folder folder) {
    return FolderModel(
      id: folder.id,
      name: folder.name,
      description: folder.description,
      color: folder.color,
      deckCount: folder.deckCount,
      createdAt: folder.createdAt,
      updatedAt: folder.updatedAt,
    );
  }
}
