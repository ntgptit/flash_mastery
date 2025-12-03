import 'package:dartz/dartz.dart';

import 'package:flash_mastery/core/constants/config/app_constants.dart';
import 'package:flash_mastery/core/constants/validation/error_messages.dart';
import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/deck_local_data_source.dart';
import 'package:flash_mastery/data/datasources/folder_local_data_source.dart';
import 'package:flash_mastery/data/models/deck_model.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/repositories/deck_repository.dart';

class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDataSource deckLocalDataSource;
  final FolderLocalDataSource folderLocalDataSource;

  DeckRepositoryImpl({
    required this.deckLocalDataSource,
    required this.folderLocalDataSource,
  });

  @override
  Future<Either<Failure, Deck>> createDeck({
    required String name,
    String? description,
    String? folderId,
  }) async {
    final trimmedName = name.trim();
    final trimmedDescription = description?.trim();

    final validationFailure = _validateNameAndDescription(
      trimmedName,
      trimmedDescription,
    );
    if (validationFailure != null) return Left(validationFailure);

    return ErrorGuard.run(() async {
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

      return createdDeck.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteDeck(String id) async {
    return ErrorGuard.run(() async {
      final deck = await deckLocalDataSource.getDeckById(id);
      await deckLocalDataSource.deleteDeck(id);

      if (deck.folderId != null) {
        await _updateFolderDeckCount(deck.folderId!, -1);
      }

      return;
    });
  }

  @override
  Future<Either<Failure, Deck>> getDeckById(String id) async {
    return ErrorGuard.run(() async {
      final deck = await deckLocalDataSource.getDeckById(id);
      return deck.toEntity();
    });
  }

  @override
  Future<Either<Failure, List<Deck>>> getDecks({String? folderId}) async {
    return ErrorGuard.run(() async {
      final decks = await deckLocalDataSource.getDecks(folderId: folderId);
      return decks.map((d) => d.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<Deck>>> searchDecks(
    String query, {
    String? folderId,
  }) async {
    return ErrorGuard.run(() async {
      final decks = await deckLocalDataSource.searchDecks(query, folderId: folderId);
      return decks.map((d) => d.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Deck>> updateDeck({
    required String id,
    String? name,
    String? description,
    String? folderId,
  }) async {
    final trimmedName = name?.trim();
    final trimmedDescription = description?.trim();

    final validationFailure = _validateNameAndDescription(
      trimmedName ?? '',
      trimmedDescription,
      allowEmptyName: trimmedName == null,
    );
    if (validationFailure != null) return Left(validationFailure);

    return ErrorGuard.run(() async {
      final existingDeck = await deckLocalDataSource.getDeckById(id);
      final String? oldFolderId = existingDeck.folderId;

      if (folderId != null && folderId != oldFolderId) {
        await _ensureFolderExists(folderId);
      }

      final updatedDeck = existingDeck.copyWith(
        name: trimmedName ?? existingDeck.name,
        description: trimmedDescription ?? existingDeck.description,
        folderId: folderId ?? existingDeck.folderId,
      );

      final result = await deckLocalDataSource.updateDeck(updatedDeck);

      if (folderId != null && folderId != oldFolderId) {
        if (oldFolderId != null) {
          await _updateFolderDeckCount(oldFolderId, -1);
        }
        await _updateFolderDeckCount(folderId, 1);
      }

      return result.toEntity();
    });
  }

  Failure? _validateNameAndDescription(
    String name,
    String? description, {
    bool allowEmptyName = false,
  }) {
    if (!allowEmptyName && name.isEmpty) {
      return ValidationFailure(message: ErrorMessages.deckNameRequired);
    }

    if (name.isNotEmpty && name.length < AppConstants.minDeckNameLength) {
      return ValidationFailure(message: ErrorMessages.textTooShort(AppConstants.minDeckNameLength));
    }

    if (name.isNotEmpty && name.length > AppConstants.maxDeckNameLength) {
      return ValidationFailure(message: ErrorMessages.textTooLong(AppConstants.maxDeckNameLength));
    }

    if (description != null && description.length > AppConstants.maxDeckDescriptionLength) {
      return ValidationFailure(
        message: ErrorMessages.textTooLong(AppConstants.maxDeckDescriptionLength),
      );
    }

    return null;
  }

  Future<void> _ensureFolderExists(String folderId) async {
    await folderLocalDataSource.getFolderById(folderId);
  }

  Future<void> _updateFolderDeckCount(String folderId, int delta) async {
    final folder = await folderLocalDataSource.getFolderById(folderId);
    final nextCount = folder.deckCount + delta;
    final updatedFolder = folder.copyWith(deckCount: nextCount < 0 ? 0 : nextCount);
    await folderLocalDataSource.updateFolder(updatedFolder);
  }
}
