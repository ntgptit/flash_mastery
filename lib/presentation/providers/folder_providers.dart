import 'package:flash_mastery/data/datasources/local/folder_local_data_source.dart';
import 'package:flash_mastery/data/repositories/folder_repository_impl.dart';
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
