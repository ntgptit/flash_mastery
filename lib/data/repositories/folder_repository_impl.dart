import 'package:dartz/dartz.dart';

import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/local/folder_local_data_source.dart';
import 'package:flash_mastery/data/models/folder_model.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/domain/repositories/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  final FolderLocalDataSource localDataSource;

  FolderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Folder>>> getFolders() async {
    return ErrorGuard.run(() async {
      final folders = await localDataSource.getFolders();
      return folders.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Folder>> getFolderById(String id) async {
    return ErrorGuard.run(() async {
      final folder = await localDataSource.getFolderById(id);
      return folder.toEntity();
    });
  }

  @override
  Future<Either<Failure, Folder>> createFolder({
    required String name,
    String? description,
    String? color,
  }) async {
    return ErrorGuard.run(() async {
      final folderModel = FolderModel(
        id: '',
        name: name,
        description: description,
        color: color,
        deckCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdFolder = await localDataSource.createFolder(folderModel);
      return createdFolder.toEntity();
    });
  }

  @override
  Future<Either<Failure, Folder>> updateFolder({
    required String id,
    String? name,
    String? description,
    String? color,
  }) async {
    return ErrorGuard.run(() async {
      final existingFolder = await localDataSource.getFolderById(id);
      final updatedFolder = existingFolder.copyWith(
        name: name ?? existingFolder.name,
        description: description ?? existingFolder.description,
        color: color ?? existingFolder.color,
      );

      final result = await localDataSource.updateFolder(updatedFolder);
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteFolder(String id) async {
    return ErrorGuard.run(() async {
      await localDataSource.deleteFolder(id);
      return;
    });
  }

  @override
  Future<Either<Failure, List<Folder>>> searchFolders(String query) async {
    return ErrorGuard.run(() async {
      final folders = await localDataSource.searchFolders(query);
      return folders.map((model) => model.toEntity()).toList();
    });
  }
}
