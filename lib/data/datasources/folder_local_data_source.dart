import 'package:flash_mastery/data/models/folder_model.dart';

/// Local data source for folder operations
/// Currently using in-memory storage, can be replaced with Hive/SQLite later
abstract class FolderLocalDataSource {
  Future<List<FolderModel>> getFolders();
  Future<FolderModel> getFolderById(String id);
  Future<FolderModel> createFolder(FolderModel folder);
  Future<FolderModel> updateFolder(FolderModel folder);
  Future<void> deleteFolder(String id);
  Future<List<FolderModel>> searchFolders(String query);
}

class FolderLocalDataSourceImpl implements FolderLocalDataSource {
  // In-memory storage (replace with Hive/SQLite in production)
  final List<FolderModel> _folders = [];

  @override
  Future<List<FolderModel>> getFolders() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_folders);
  }

  @override
  Future<FolderModel> getFolderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _folders.firstWhere((folder) => folder.id == id);
    } catch (e) {
      throw Exception('Folder not found');
    }
  }

  @override
  Future<FolderModel> createFolder(FolderModel folder) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newFolder = folder.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _folders.add(newFolder);
    return newFolder;
  }

  @override
  Future<FolderModel> updateFolder(FolderModel folder) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _folders.indexWhere((f) => f.id == folder.id);
    if (index == -1) {
      throw Exception('Folder not found');
    }

    final updatedFolder = folder.copyWith(updatedAt: DateTime.now());
    _folders[index] = updatedFolder;
    return updatedFolder;
  }

  @override
  Future<void> deleteFolder(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _folders.indexWhere((f) => f.id == id);
    if (index == -1) {
      throw Exception('Folder not found');
    }

    _folders.removeAt(index);
  }

  @override
  Future<List<FolderModel>> searchFolders(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) {
      return List.from(_folders);
    }

    return _folders
        .where(
          (folder) =>
              folder.name.toLowerCase().contains(query.toLowerCase()) ||
              (folder.description?.toLowerCase().contains(query.toLowerCase()) ?? false),
        )
        .toList();
  }
}
