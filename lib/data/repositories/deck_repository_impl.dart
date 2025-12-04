import 'package:dartz/dartz.dart';

import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/local/deck_local_data_source.dart';
import 'package:flash_mastery/data/datasources/local/folder_local_data_source.dart';
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
    return ErrorGuard.run(() async {
      if (folderId != null) {
        await _ensureFolderExists(folderId);
      }

      final deckModel = DeckModel(
        id: '',
        name: name,
        description: description,
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
    return ErrorGuard.run(() async {
      final existingDeck = await deckLocalDataSource.getDeckById(id);
      final String? oldFolderId = existingDeck.folderId;

      if (folderId != null && folderId != oldFolderId) {
        await _ensureFolderExists(folderId);
      }

      final updatedDeck = existingDeck.copyWith(
        name: name ?? existingDeck.name,
        description: description ?? existingDeck.description,
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
