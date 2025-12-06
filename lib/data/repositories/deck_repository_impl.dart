import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/remote/deck_remote_data_source.dart';
import 'package:flash_mastery/data/models/deck_model.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';
import 'package:flash_mastery/domain/entities/import_summary.dart';
import 'package:flash_mastery/domain/repositories/deck_repository.dart';

class DeckRepositoryImpl implements DeckRepository {
  final DeckRemoteDataSource remoteDataSource;

  DeckRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Deck>> createDeck({
    required String name,
    String? description,
    String? folderId,
    required FlashcardType type,
  }) async {
    return ErrorGuard.run(() async {
      final deckModel = DeckModel(
        id: '',
        name: name,
        description: description,
        folderId: folderId,
        cardCount: 0,
        type: type,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await remoteDataSource.createDeck(deckModel);
      return created.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteDeck(String id) async {
    return ErrorGuard.run(() async {
      await remoteDataSource.deleteDeck(id);
      return;
    });
  }

  @override
  Future<Either<Failure, Deck>> getDeckById(String id) async {
    return ErrorGuard.run(() async {
      final deck = await remoteDataSource.getDeckById(id);
      return deck.toEntity();
    });
  }

  @override
  Future<Either<Failure, List<Deck>>> getDecks({
    String? folderId,
    String? sort,
    String? query,
    int page = 0,
    int size = 20,
  }) async {
    return ErrorGuard.run(() async {
      final decks = await remoteDataSource.getDecks(
        folderId: folderId,
        sort: sort,
        query: query,
        page: page,
        size: size,
      );
      return decks.map((d) => d.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<Deck>>> searchDecks(
    String query, {
    String? folderId,
  }) async {
    return ErrorGuard.run(() async {
      final decks = await remoteDataSource.searchDecks(
        query,
        folderId: folderId,
      );
      return decks.map((d) => d.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Deck>> updateDeck({
    required String id,
    String? name,
    String? description,
    String? folderId,
    FlashcardType? type,
  }) async {
    return ErrorGuard.run(() async {
      final existingDeck = await remoteDataSource.getDeckById(id);
      final updatedDeck = existingDeck.copyWith(
        name: name ?? existingDeck.name,
        description: description ?? existingDeck.description,
        folderId: folderId ?? existingDeck.folderId,
        type: type ?? existingDeck.type,
      );

      final result = await remoteDataSource.updateDeck(id, updatedDeck);
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, ImportSummary>> importDecks({
    required String folderId,
    required FlashcardType type,
    required PlatformFile file,
  }) async {
    return ErrorGuard.run(() async {
      if (file.path == null) {
        throw ArgumentError('File path is null');
      }
      final summary = await remoteDataSource.importDecks(
        folderId: folderId,
        type: type.name.toUpperCase(),
        filePath: file.path!,
        fileName: file.name,
      );
      return summary.toEntity();
    });
  }
}
