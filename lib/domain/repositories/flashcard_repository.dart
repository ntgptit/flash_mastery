import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';

/// Repository interface for flashcard operations.
abstract class FlashcardRepository {
  /// Get all cards for a deck.
  Future<Either<Failure, List<Flashcard>>> getFlashcards(String deckId);

  /// Get a flashcard by id.
  Future<Either<Failure, Flashcard>> getFlashcardById(String id);

  /// Create a flashcard.
  Future<Either<Failure, Flashcard>> createFlashcard({
    required String deckId,
    required String question,
    required String answer,
    String? hint,
    FlashcardType type,
  });

  /// Update a flashcard.
  Future<Either<Failure, Flashcard>> updateFlashcard({
    required String id,
    String? question,
    String? answer,
    String? hint,
    FlashcardType? type,
  });

  /// Delete a flashcard.
  Future<Either<Failure, void>> deleteFlashcard(String id);

  /// Search flashcards by text in a deck.
  Future<Either<Failure, List<Flashcard>>> searchFlashcards(String deckId, String query);
}
