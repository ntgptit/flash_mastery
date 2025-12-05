import 'package:dartz/dartz.dart';

import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/remote/folder_remote_data_source.dart';
import 'package:flash_mastery/data/models/folder_model.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/domain/repositories/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  final FolderRemoteDataSource remoteDataSource;

  FolderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Folder>>> getFolders({String? parentId}) async {
    return ErrorGuard.run(() async {
      final folders = await remoteDataSource.getFolders(parentId: parentId);
      return folders.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Folder>> getFolderById(String id) async {
    return ErrorGuard.run(() async {
      final folder = await remoteDataSource.getFolderById(id);
      return folder.toEntity();
    });
  }

  @override
  Future<Either<Failure, Folder>> createFolder({
    required String name,
    String? description,
    String? color,
    String? parentId,
  }) async {
    return ErrorGuard.run(() async {
      final createdFolder = await remoteDataSource.createFolder(
        FolderModel(
          id: '',
          name: name,
          description: description,
          color: color,
          deckCount: 0,
          parentId: parentId,
          subFolderCount: 0,
          path: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      return createdFolder.toEntity();
    });
  }

  @override
  Future<Either<Failure, Folder>> updateFolder({
    required String id,
    String? name,
    String? description,
    String? color,
    String? parentId,
  }) async {
    return ErrorGuard.run(() async {
      final existingFolder = await remoteDataSource.getFolderById(id);
      final updatedFolder = existingFolder.copyWith(
        name: name ?? existingFolder.name,
        description: description ?? existingFolder.description,
        color: color ?? existingFolder.color,
        parentId: parentId ?? existingFolder.parentId,
      );

      final result = await remoteDataSource.updateFolder(id, updatedFolder);
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteFolder(String id) async {
    return ErrorGuard.run(() async {
      await remoteDataSource.deleteFolder(id);
      return;
    });
  }

  @override
  Future<Either<Failure, List<Folder>>> searchFolders(String query) async {
    return ErrorGuard.run(() async {
      final folders = await remoteDataSource.searchFolders(query);
      return folders.map((model) => model.toEntity()).toList();
    });
  }
}
