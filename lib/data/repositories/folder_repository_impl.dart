import 'package:dartz/dartz.dart';

import 'package:flash_mastery/core/constants/config/app_constants.dart';
import 'package:flash_mastery/core/constants/validation/error_messages.dart';
import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/folder_local_data_source.dart';
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
    final trimmedName = name.trim();
    final trimmedDescription = description?.trim();
    final validationFailure = _validateFolder(
      trimmedName,
      trimmedDescription,
    );
    if (validationFailure != null) return Left(validationFailure);

    return ErrorGuard.run(() async {
      final folderModel = FolderModel(
        id: '',
        name: trimmedName,
        description: trimmedDescription,
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
    final trimmedName = name?.trim();
    final trimmedDescription = description?.trim();
    final validationFailure = _validateFolder(
      trimmedName ?? '',
      trimmedDescription,
      allowEmptyName: trimmedName == null,
    );
    if (validationFailure != null) return Left(validationFailure);

    return ErrorGuard.run(() async {
      final existingFolder = await localDataSource.getFolderById(id);
      final updatedFolder = existingFolder.copyWith(
        name: trimmedName ?? existingFolder.name,
        description: trimmedDescription ?? existingFolder.description,
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

  Failure? _validateFolder(
    String name,
    String? description, {
    bool allowEmptyName = false,
  }) {
    if (!allowEmptyName && name.isEmpty) {
      return ValidationFailure(message: ErrorMessages.fieldRequired);
    }

    if (name.isNotEmpty && name.length < AppConstants.minFolderNameLength) {
      return ValidationFailure(
        message: ErrorMessages.textTooShort(AppConstants.minFolderNameLength),
      );
    }

    if (name.isNotEmpty && name.length > AppConstants.maxFolderNameLength) {
      return ValidationFailure(
        message: ErrorMessages.textTooLong(AppConstants.maxFolderNameLength),
      );
    }

    if (description != null && description.length > AppConstants.maxFolderDescriptionLength) {
      return ValidationFailure(
        message: ErrorMessages.textTooLong(AppConstants.maxFolderDescriptionLength),
      );
    }

    return null;
  }
}
