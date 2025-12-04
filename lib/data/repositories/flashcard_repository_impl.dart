import 'package:dartz/dartz.dart';

import 'package:flash_mastery/core/constants/config/app_constants.dart';
import 'package:flash_mastery/core/constants/validation/error_messages.dart';
import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/local/deck_local_data_source.dart';
import 'package:flash_mastery/data/datasources/local/flashcard_local_data_source.dart';
import 'package:flash_mastery/data/models/flashcard_model.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/repositories/flashcard_repository.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardLocalDataSource flashcardLocalDataSource;
  final DeckLocalDataSource deckLocalDataSource;

  FlashcardRepositoryImpl({
    required this.flashcardLocalDataSource,
    required this.deckLocalDataSource,
  });

  @override
  Future<Either<Failure, Flashcard>> createFlashcard({
    required String deckId,
    required String question,
    required String answer,
    String? hint,
  }) async {
    return ErrorGuard.run(() async {
      final deck = await deckLocalDataSource.getDeckById(deckId);
      if (deck.cardCount >= AppConstants.maxFlashcardsPerDeck) {
        throw ValidationFailure(
          message: ErrorMessages.maxCardsReached(AppConstants.maxFlashcardsPerDeck),
        );
      }

      final card = FlashcardModel(
        id: '',
        deckId: deckId,
        question: question,
        answer: answer,
        hint: hint,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final created = await flashcardLocalDataSource.createFlashcard(card);
      await _updateDeckCardCount(deckId: deckId, delta: 1);
      return created.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteFlashcard(String id) async {
    return ErrorGuard.run(() async {
      final existing = await flashcardLocalDataSource.getFlashcardById(id);
      await flashcardLocalDataSource.deleteFlashcard(id);
      await _updateDeckCardCount(deckId: existing.deckId, delta: -1);
      return;
    });
  }

  @override
  Future<Either<Failure, Flashcard>> getFlashcardById(String id) async {
    return ErrorGuard.run(() async {
      final card = await flashcardLocalDataSource.getFlashcardById(id);
      return card.toEntity();
    });
  }

  @override
  Future<Either<Failure, List<Flashcard>>> getFlashcards(String deckId) async {
    return ErrorGuard.run(() async {
      final cards = await flashcardLocalDataSource.getFlashcards(deckId);
      return cards.map((c) => c.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<Flashcard>>> searchFlashcards(
    String deckId,
    String query,
  ) async {
    return ErrorGuard.run(() async {
      final cards = await flashcardLocalDataSource.searchFlashcards(deckId, query);
      return cards.map((c) => c.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Flashcard>> updateFlashcard({
    required String id,
    String? question,
    String? answer,
    String? hint,
  }) async {
    return ErrorGuard.run(() async {
      final existing = await flashcardLocalDataSource.getFlashcardById(id);
      final updated = existing.copyWith(
        question: question ?? existing.question,
        answer: answer ?? existing.answer,
        hint: hint ?? existing.hint,
      );
      final saved = await flashcardLocalDataSource.updateFlashcard(updated);
      return saved.toEntity();
    });
  }

  Future<void> _updateDeckCardCount({
    required String deckId,
    required int delta,
  }) async {
    final deck = await deckLocalDataSource.getDeckById(deckId);
    final nextCount =
        (deck.cardCount + delta).clamp(0, AppConstants.maxFlashcardsPerDeck).toInt();
    await deckLocalDataSource.updateDeck(deck.copyWith(cardCount: nextCount));
  }
}
