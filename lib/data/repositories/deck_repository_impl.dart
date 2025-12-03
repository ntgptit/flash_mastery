import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/constants/config/app_constants.dart';
import 'package:flash_mastery/core/constants/validation/error_messages.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/deck_local_data_source.dart';
import 'package:flash_mastery/data/datasources/folder_local_data_source.dart';
import 'package:flash_mastery/data/models/deck_model.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/repositories/deck_repository.dart';

class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDataSource deckLocalDataSource;
  final FolderLocalDataSource folderLocalDataSource;

  DeckRepositoryImpl({required this.deckLocalDataSource, required this.folderLocalDataSource});

  @override
  Future<Either<Failure, Deck>> createDeck({
    required String name,
    String? description,
    String? folderId,
  }) async {
    try {
      final trimmedName = name.trim();
      final trimmedDescription = description?.trim();
      if (trimmedName.isEmpty) {
        return Left(ValidationFailure(message: ErrorMessages.deckNameRequired));
      }

      if (trimmedName.length < AppConstants.minDeckNameLength) {
        return Left(
          ValidationFailure(message: ErrorMessages.textTooShort(AppConstants.minDeckNameLength)),
        );
      }

      if (trimmedName.length > AppConstants.maxDeckNameLength) {
        return Left(
          ValidationFailure(message: ErrorMessages.textTooLong(AppConstants.maxDeckNameLength)),
        );
      }

      if (trimmedDescription != null &&
          trimmedDescription.length > AppConstants.maxDeckDescriptionLength) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.textTooLong(AppConstants.maxDeckDescriptionLength),
          ),
        );
      }

      if (folderId != null) {
        await _ensureFolderExists(folderId);
      }

      final deckModel = DeckModel(
        id: '',
        name: trimmedName,
        description: trimmedDescription,
        folderId: folderId,
        cardCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdDeck = await deckLocalDataSource.createDeck(deckModel);

      if (folderId != null) {
        await _updateFolderDeckCount(folderId, 1);
      }

      return Right(createdDeck.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDeck(String id) async {
    try {
      final deck = await deckLocalDataSource.getDeckById(id);
      await deckLocalDataSource.deleteDeck(id);

      if (deck.folderId != null) {
        await _updateFolderDeckCount(deck.folderId!, -1);
      }

      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Deck>> getDeckById(String id) async {
    try {
      final deck = await deckLocalDataSource.getDeckById(id);
      return Right(deck.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Deck>>> getDecks({String? folderId}) async {
    try {
      final decks = await deckLocalDataSource.getDecks(folderId: folderId);
      return Right(decks.map((d) => d.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Deck>>> searchDecks(String query, {String? folderId}) async {
    try {
      final decks = await deckLocalDataSource.searchDecks(query, folderId: folderId);
      return Right(decks.map((d) => d.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Deck>> updateDeck({
    required String id,
    String? name,
    String? description,
    String? folderId,
  }) async {
    try {
      final existingDeck = await deckLocalDataSource.getDeckById(id);
      final String? oldFolderId = existingDeck.folderId;
      final trimmedName = name?.trim();
      final trimmedDescription = description?.trim();

      if (folderId != null && folderId != oldFolderId) {
        await _ensureFolderExists(folderId);
      }

      if (trimmedName != null && trimmedName.isEmpty) {
        return Left(ValidationFailure(message: ErrorMessages.deckNameRequired));
      }

      if (trimmedName != null && trimmedName.length < AppConstants.minDeckNameLength) {
        return Left(
          ValidationFailure(message: ErrorMessages.textTooShort(AppConstants.minDeckNameLength)),
        );
      }

      if (trimmedName != null && trimmedName.length > AppConstants.maxDeckNameLength) {
        return Left(
          ValidationFailure(message: ErrorMessages.textTooLong(AppConstants.maxDeckNameLength)),
        );
      }

      if (trimmedDescription != null &&
          trimmedDescription.length > AppConstants.maxDeckDescriptionLength) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.textTooLong(AppConstants.maxDeckDescriptionLength),
          ),
        );
      }

      final updatedDeck = existingDeck.copyWith(
        name: trimmedName,
        description: trimmedDescription,
        folderId: folderId ?? existingDeck.folderId,
      );

      final result = await deckLocalDataSource.updateDeck(updatedDeck);

      if (folderId != null && folderId != oldFolderId) {
        if (oldFolderId != null) {
          await _updateFolderDeckCount(oldFolderId, -1);
        }
        await _updateFolderDeckCount(folderId, 1);
      }

      return Right(result.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<void> _ensureFolderExists(String folderId) async {
    try {
      await folderLocalDataSource.getFolderById(folderId);
    } catch (_) {
      throw const NotFoundException(message: ErrorMessages.folderNotFound);
    }
  }

  Future<void> _updateFolderDeckCount(String folderId, int delta) async {
    final folder = await folderLocalDataSource.getFolderById(folderId);
    final nextCount = folder.deckCount + delta;
    final updatedFolder = folder.copyWith(deckCount: nextCount < 0 ? 0 : nextCount);
    await folderLocalDataSource.updateFolder(updatedFolder);
  }
}
