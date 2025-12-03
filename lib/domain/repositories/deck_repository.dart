import 'package:dartz/dartz.dart';
import '../../core/exceptions/failures.dart';
import '../entities/deck.dart';

/// Repository interface for deck operations.
abstract class DeckRepository {
  /// Get all decks, optionally filtered by folder.
  Future<Either<Failure, List<Deck>>> getDecks({String? folderId});

  /// Get deck by ID.
  Future<Either<Failure, Deck>> getDeckById(String id);

  /// Create a new deck.
  Future<Either<Failure, Deck>> createDeck({
    required String name,
    String? description,
    String? folderId,
  });

  /// Update an existing deck.
  Future<Either<Failure, Deck>> updateDeck({
    required String id,
    String? name,
    String? description,
    String? folderId,
  });

  /// Delete a deck by ID.
  Future<Either<Failure, void>> deleteDeck(String id);

  /// Search decks by text, optionally scoped to a folder.
  Future<Either<Failure, List<Deck>>> searchDecks(
    String query, {
    String? folderId,
  });
}
