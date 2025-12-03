import 'package:dartz/dartz.dart';
import '../../core/exceptions/failures.dart';
import '../entities/folder.dart';

/// Repository interface for folder operations
abstract class FolderRepository {
  /// Get all folders
  Future<Either<Failure, List<Folder>>> getFolders();

  /// Get folder by ID
  Future<Either<Failure, Folder>> getFolderById(String id);

  /// Create new folder
  Future<Either<Failure, Folder>> createFolder({
    required String name,
    String? description,
    String? color,
  });

  /// Update existing folder
  Future<Either<Failure, Folder>> updateFolder({
    required String id,
    String? name,
    String? description,
    String? color,
  });

  /// Delete folder
  Future<Either<Failure, void>> deleteFolder(String id);

  /// Search folders by name
  Future<Either<Failure, List<Folder>>> searchFolders(String query);
}
