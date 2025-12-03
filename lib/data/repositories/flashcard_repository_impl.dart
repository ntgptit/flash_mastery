import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/constants/config/app_constants.dart';
import 'package:flash_mastery/core/constants/validation/error_messages.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/deck_local_data_source.dart';
import 'package:flash_mastery/data/datasources/flashcard_local_data_source.dart';
import 'package:flash_mastery/data/models/deck_model.dart';
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
    try {
      final deck = await deckLocalDataSource.getDeckById(deckId);
      if (deck.cardCount >= AppConstants.maxFlashcardsPerDeck) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.maxCardsReached(AppConstants.maxFlashcardsPerDeck),
          ),
        );
      }
      final trimmedQuestion = question.trim();
      final trimmedAnswer = answer.trim();
      final trimmedHint = hint?.trim();
      if (trimmedQuestion.isEmpty) {
        return Left(ValidationFailure(message: ErrorMessages.questionRequired));
      }
      if (trimmedAnswer.isEmpty) {
        return Left(ValidationFailure(message: ErrorMessages.answerRequired));
      }
      if (trimmedQuestion.length > AppConstants.maxQuestionLength) {
        return Left(
          ValidationFailure(message: ErrorMessages.textTooLong(AppConstants.maxQuestionLength)),
        );
      }
      if (trimmedAnswer.length > AppConstants.maxAnswerLength) {
        return Left(
          ValidationFailure(message: ErrorMessages.textTooLong(AppConstants.maxAnswerLength)),
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
      return Right(created.toEntity());
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
  Future<Either<Failure, void>> deleteFlashcard(String id) async {
    try {
      final existing = await flashcardLocalDataSource.getFlashcardById(id);
      await flashcardLocalDataSource.deleteFlashcard(id);
      await _updateDeckCardCount(deckId: existing.deckId, delta: -1);
      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Flashcard>> getFlashcardById(String id) async {
    try {
      final card = await flashcardLocalDataSource.getFlashcardById(id);
      return Right(card.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Flashcard>>> getFlashcards(String deckId) async {
    try {
      final cards = await flashcardLocalDataSource.getFlashcards(deckId);
      return Right(cards.map((c) => c.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Flashcard>>> searchFlashcards(
    String deckId,
    String query,
  ) async {
    try {
      final cards = await flashcardLocalDataSource.searchFlashcards(deckId, query);
      return Right(cards.map((c) => c.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Flashcard>> updateFlashcard({
    required String id,
    String? question,
    String? answer,
    String? hint,
  }) async {
    try {
      final existing = await flashcardLocalDataSource.getFlashcardById(id);
      final trimmedQuestion = question?.trim();
      final trimmedAnswer = answer?.trim();
      final trimmedHint = hint?.trim();

      if (trimmedQuestion != null && trimmedQuestion.isEmpty) {
        return Left(ValidationFailure(message: ErrorMessages.questionRequired));
      }
      if (trimmedAnswer != null && trimmedAnswer.isEmpty) {
        return Left(ValidationFailure(message: ErrorMessages.answerRequired));
      }
      if (trimmedQuestion != null && trimmedQuestion.length > AppConstants.maxQuestionLength) {
        return Left(
          ValidationFailure(message: ErrorMessages.textTooLong(AppConstants.maxQuestionLength)),
        );
      }
      if (trimmedAnswer != null && trimmedAnswer.length > AppConstants.maxAnswerLength) {
        return Left(
          ValidationFailure(message: ErrorMessages.textTooLong(AppConstants.maxAnswerLength)),
        );
      }

      final updated = existing.copyWith(
        question: trimmedQuestion ?? existing.question,
        answer: trimmedAnswer ?? existing.answer,
        hint: trimmedHint ?? existing.hint,
      );
      final saved = await flashcardLocalDataSource.updateFlashcard(updated);
      return Right(saved.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<void> _updateDeckCardCount({
    required String deckId,
    required int delta,
  }) async {
    final DeckModel deck = await deckLocalDataSource.getDeckById(deckId);
    final nextCount =
        (deck.cardCount + delta).clamp(0, AppConstants.maxFlashcardsPerDeck).toInt();
    await deckLocalDataSource.updateDeck(deck.copyWith(cardCount: nextCount));
  }
}
