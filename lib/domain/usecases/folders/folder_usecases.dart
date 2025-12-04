import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/constants/config/app_constants.dart';
import 'package:flash_mastery/core/constants/validation/error_messages.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/core/usecases/usecase.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/domain/repositories/folder_repository.dart';

class GetFoldersUseCase extends UseCase<List<Folder>, NoParams> {
  final FolderRepository repository;

  GetFoldersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Folder>>> call(NoParams params) {
    return repository.getFolders();
  }
}

class GetFolderByIdUseCase extends UseCase<Folder, String> {
  final FolderRepository repository;

  GetFolderByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Folder>> call(String id) {
    return repository.getFolderById(id);
  }
}

class SearchFoldersUseCase extends UseCase<List<Folder>, String> {
  final FolderRepository repository;

  SearchFoldersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Folder>>> call(String query) {
    return repository.searchFolders(query);
  }
}

class CreateFolderUseCase extends UseCase<Folder, CreateFolderParams> {
  final FolderRepository repository;

  CreateFolderUseCase(this.repository);

  @override
  Future<Either<Failure, Folder>> call(CreateFolderParams params) async {
    final trimmedName = params.name.trim();
    final trimmedDescription = params.description?.trim();

    final validationFailure = _validateFolder(
      trimmedName,
      trimmedDescription,
    );
    if (validationFailure != null) return Left(validationFailure);

    return repository.createFolder(
      name: trimmedName,
      description: trimmedDescription,
      color: params.color,
    );
  }
}

class UpdateFolderUseCase extends UseCase<Folder, UpdateFolderParams> {
  final FolderRepository repository;

  UpdateFolderUseCase(this.repository);

  @override
  Future<Either<Failure, Folder>> call(UpdateFolderParams params) async {
    final trimmedName = params.name?.trim();
    final trimmedDescription = params.description?.trim();
    final validationFailure = _validateFolder(
      trimmedName ?? '',
      trimmedDescription,
      allowEmptyName: trimmedName == null,
    );
    if (validationFailure != null) return Left(validationFailure);

    return repository.updateFolder(
      id: params.id,
      name: trimmedName,
      description: trimmedDescription,
      color: params.color,
    );
  }
}

class DeleteFolderUseCase extends UseCase<void, String> {
  final FolderRepository repository;

  DeleteFolderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteFolder(id);
  }
}

class CreateFolderParams {
  final String name;
  final String? description;
  final String? color;

  const CreateFolderParams({
    required this.name,
    this.description,
    this.color,
  });
}

class UpdateFolderParams {
  final String id;
  final String? name;
  final String? description;
  final String? color;

  const UpdateFolderParams({
    required this.id,
    this.name,
    this.description,
    this.color,
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
