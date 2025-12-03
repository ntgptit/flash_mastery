import 'package:dartz/dartz.dart';

import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/domain/repositories/folder_repository.dart';

class GetFoldersUseCase {
  final FolderRepository repository;

  const GetFoldersUseCase(this.repository);

  Future<Either<Failure, List<Folder>>> call() {
    return repository.getFolders();
  }
}

class CreateFolderUseCase {
  final FolderRepository repository;

  const CreateFolderUseCase(this.repository);

  Future<Either<Failure, Folder>> call(CreateFolderParams params) {
    return repository.createFolder(
      name: params.name,
      description: params.description,
      color: params.color,
    );
  }
}

class UpdateFolderUseCase {
  final FolderRepository repository;

  const UpdateFolderUseCase(this.repository);

  Future<Either<Failure, Folder>> call(UpdateFolderParams params) {
    return repository.updateFolder(
      id: params.id,
      name: params.name,
      description: params.description,
      color: params.color,
    );
  }
}

class DeleteFolderUseCase {
  final FolderRepository repository;

  const DeleteFolderUseCase(this.repository);

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
