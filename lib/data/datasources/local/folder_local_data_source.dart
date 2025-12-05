import 'package:drift/drift.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/data/local/app_database.dart';
import 'package:flash_mastery/data/models/folder_model.dart';
import 'package:uuid/uuid.dart';

/// Local data source for folder operations (Drift + SQLite).
abstract class FolderLocalDataSource {
  Future<List<FolderModel>> getFolders({String? parentId});
  Future<FolderModel> getFolderById(String id);
  Future<FolderModel> createFolder(FolderModel folder);
  Future<FolderModel> updateFolder(FolderModel folder);
  Future<void> deleteFolder(String id);
  Future<List<FolderModel>> searchFolders(String query);
}

class FolderLocalDataSourceImpl implements FolderLocalDataSource {
  FolderLocalDataSourceImpl({required this.db});

  final AppDatabase db;
  final _uuid = const Uuid();

  @override
  Future<List<FolderModel>> getFolders({String? parentId}) async {
    final query = db.select(db.folders);
    if (parentId != null) {
      query.where((tbl) => tbl.parentId.equals(parentId));
    }
    final rows = await query.get();
    return rows.map(_mapRowToModel).toList();
  }

  @override
  Future<FolderModel> getFolderById(String id) async {
    final row =
        await (db.select(db.folders)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) throw const NotFoundException(message: 'Folder not found');
    return _mapRowToModel(row);
  }

  @override
  Future<FolderModel> createFolder(FolderModel folder) async {
    final now = DateTime.now();
    final newFolder = folder.copyWith(
      id: folder.id.isEmpty ? _uuid.v4() : folder.id,
      createdAt: now,
      updatedAt: now,
    );

    await db.into(db.folders).insert(
          FoldersCompanion.insert(
            id: newFolder.id,
            name: newFolder.name,
            description: Value(newFolder.description),
            color: Value(newFolder.color),
            deckCount: Value(newFolder.deckCount),
            parentId: Value(newFolder.parentId),
            subFolderCount: Value(newFolder.subFolderCount),
            createdAt: newFolder.createdAt,
            updatedAt: newFolder.updatedAt,
          ),
        );
    return newFolder;
  }

  @override
  Future<FolderModel> updateFolder(FolderModel folder) async {
    final existing =
        await (db.select(db.folders)..where((tbl) => tbl.id.equals(folder.id)))
            .getSingleOrNull();
    if (existing == null) throw const NotFoundException(message: 'Folder not found');

    final updated = folder.copyWith(updatedAt: DateTime.now());
    await (db.update(db.folders)..where((tbl) => tbl.id.equals(folder.id))).write(
      FoldersCompanion(
        name: Value(updated.name),
        description: Value(updated.description),
        color: Value(updated.color),
        deckCount: Value(updated.deckCount),
        parentId: Value(updated.parentId),
        subFolderCount: Value(updated.subFolderCount),
        updatedAt: Value(updated.updatedAt),
      ),
    );
    return updated;
  }

  @override
  Future<void> deleteFolder(String id) async {
    final deleted = await (db.delete(db.folders)..where((tbl) => tbl.id.equals(id))).go();
    if (deleted == 0) throw const NotFoundException(message: 'Folder not found');
  }

  @override
  Future<List<FolderModel>> searchFolders(String query) async {
    if (query.isEmpty) return getFolders();
    final lower = query.toLowerCase();
    final rows = await (db.select(db.folders)
          ..where(
            (tbl) =>
                tbl.name.lower().like('%$lower%') | tbl.description.lower().like('%$lower%'),
          ))
        .get();
    return rows.map(_mapRowToModel).toList();
  }

  FolderModel _mapRowToModel(Folder row) => FolderModel(
        id: row.id,
        name: row.name,
        description: row.description,
        color: row.color,
        deckCount: row.deckCount,
        parentId: row.parentId,
        subFolderCount: row.subFolderCount,
        level: 0,
        path: const [],
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
}
