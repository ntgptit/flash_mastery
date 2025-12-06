import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';
import 'package:flash_mastery/domain/entities/import_summary.dart';

/// Repository interface for deck operations.
abstract class DeckRepository {
  /// Get all decks, optionally filtered by folder.
  Future<Either<Failure, List<Deck>>> getDecks({
    String? folderId,
    String? sort,
    String? query,
    int page,
    int size,
  });

  /// Get deck by ID.
  Future<Either<Failure, Deck>> getDeckById(String id);

  /// Create a new deck.
  Future<Either<Failure, Deck>> createDeck({
    required String name,
    String? description,
    String? folderId,
    required FlashcardType type,
  });

  /// Update an existing deck.
  Future<Either<Failure, Deck>> updateDeck({
    required String id,
    String? name,
    String? description,
    String? folderId,
    FlashcardType? type,
  });

  Future<Either<Failure, ImportSummary>> importDecks({
    required String folderId,
    required FlashcardType type,
    required PlatformFile file,
    bool hasHeader = true,
  });

  /// Delete a deck by ID.
  Future<Either<Failure, void>> deleteDeck(String id);

  /// Search decks by text, optionally scoped to a folder.
  Future<Either<Failure, List<Deck>>> searchDecks(
    String query, {
    String? folderId,
  });
}
