import 'package:flash_mastery/data/datasources/folder_local_data_source.dart';
import 'package:flash_mastery/data/repositories/folder_repository_impl.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/domain/repositories/folder_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_providers.g.dart';

// ==================== DATA SOURCE PROVIDERS ====================

@riverpod
FolderLocalDataSource folderLocalDataSource(Ref ref) {
  return FolderLocalDataSourceImpl();
}

// ==================== REPOSITORY PROVIDERS ====================

@riverpod
FolderRepository folderRepository(Ref ref) {
  return FolderRepositoryImpl(localDataSource: ref.watch(folderLocalDataSourceProvider));
}

// ==================== STATE PROVIDERS ====================

/// Provider for fetching all folders
@riverpod
class FolderList extends _$FolderList {
  @override
  Future<List<Folder>> build() async {
    final repository = ref.watch(folderRepositoryProvider);
    final result = await repository.getFolders();

    return result.fold((failure) => throw Exception(failure.message), (folders) => folders);
  }

  /// Refresh folder list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(folderRepositoryProvider);
      final result = await repository.getFolders();

      return result.fold((failure) => throw Exception(failure.message), (folders) => folders);
    });
  }

  /// Create new folder
  Future<void> createFolder({required String name, String? description, String? color}) async {
    final repository = ref.read(folderRepositoryProvider);
    final result = await repository.createFolder(
      name: name,
      description: description,
      color: color,
    );

    result.fold((failure) => throw Exception(failure.message), (_) => refresh());
  }

  /// Update folder
  Future<void> updateFolder({
    required String id,
    String? name,
    String? description,
    String? color,
  }) async {
    final repository = ref.read(folderRepositoryProvider);
    final result = await repository.updateFolder(
      id: id,
      name: name,
      description: description,
      color: color,
    );

    result.fold((failure) => throw Exception(failure.message), (_) => refresh());
  }

  /// Delete folder
  Future<void> deleteFolder(String id) async {
    final repository = ref.read(folderRepositoryProvider);
    final result = await repository.deleteFolder(id);

    result.fold((failure) => throw Exception(failure.message), (_) => refresh());
  }
}

// ==================== SEARCH PROVIDER ====================

/// Provider for searching folders
@riverpod
class FolderSearch extends _$FolderSearch {
  @override
  Future<List<Folder>> build(String query) async {
    if (query.isEmpty) {
      return ref.watch(folderListProvider).value ?? [];
    }

    final repository = ref.watch(folderRepositoryProvider);
    final result = await repository.searchFolders(query);

    return result.fold((failure) => throw Exception(failure.message), (folders) => folders);
  }
}

// ==================== SINGLE FOLDER PROVIDER ====================

/// Provider for fetching a single folder by ID
@riverpod
Future<Folder> folder(Ref ref, String id) async {
  final repository = ref.watch(folderRepositoryProvider);
  final result = await repository.getFolderById(id);

  return result.fold((failure) => throw Exception(failure.message), (folder) => folder);
}
