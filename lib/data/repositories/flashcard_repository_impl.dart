import 'package:dartz/dartz.dart';

import 'package:flash_mastery/core/constants/config/app_constants.dart';
import 'package:flash_mastery/core/constants/validation/error_messages.dart';
import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/deck_local_data_source.dart';
import 'package:flash_mastery/data/datasources/flashcard_local_data_source.dart';
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
    final trimmedQuestion = question.trim();
    final trimmedAnswer = answer.trim();
    final trimmedHint = hint?.trim();

    final validationFailure = _validateFlashcard(trimmedQuestion, trimmedAnswer);
    if (validationFailure != null) return Left(validationFailure);

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
        question: trimmedQuestion,
        answer: trimmedAnswer,
        hint: trimmedHint,
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
    final trimmedQuestion = question?.trim();
    final trimmedAnswer = answer?.trim();
    final trimmedHint = hint?.trim();

    final validationFailure = _validateFlashcard(trimmedQuestion, trimmedAnswer, allowNull: true);
    if (validationFailure != null) return Left(validationFailure);

    return ErrorGuard.run(() async {
      final existing = await flashcardLocalDataSource.getFlashcardById(id);
      final updated = existing.copyWith(
        question: trimmedQuestion ?? existing.question,
        answer: trimmedAnswer ?? existing.answer,
        hint: trimmedHint ?? existing.hint,
      );
      final saved = await flashcardLocalDataSource.updateFlashcard(updated);
      return saved.toEntity();
    });
  }

  Failure? _validateFlashcard(
    String? question,
    String? answer, {
    bool allowNull = false,
  }) {
    if (!allowNull && (question == null || question.isEmpty)) {
      return ValidationFailure(message: ErrorMessages.questionRequired);
    }
    if (!allowNull && (answer == null || answer.isEmpty)) {
      return ValidationFailure(message: ErrorMessages.answerRequired);
    }
    if (question != null && question.isEmpty) {
      return ValidationFailure(message: ErrorMessages.questionRequired);
    }
    if (answer != null && answer.isEmpty) {
      return ValidationFailure(message: ErrorMessages.answerRequired);
    }
    if (question != null && question.length > AppConstants.maxQuestionLength) {
      return ValidationFailure(
        message: ErrorMessages.textTooLong(AppConstants.maxQuestionLength),
      );
    }
    if (answer != null && answer.length > AppConstants.maxAnswerLength) {
      return ValidationFailure(
        message: ErrorMessages.textTooLong(AppConstants.maxAnswerLength),
      );
    }
    return null;
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
