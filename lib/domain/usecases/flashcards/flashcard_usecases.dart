import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/constants/config/app_constants.dart';
import 'package:flash_mastery/core/constants/validation/error_messages.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/core/usecases/usecase.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';
import 'package:flash_mastery/domain/repositories/flashcard_repository.dart';

class GetFlashcardsUseCase extends UseCase<List<Flashcard>, String> {
  final FlashcardRepository repository;

  GetFlashcardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Flashcard>>> call(String deckId) {
    return repository.getFlashcards(deckId);
  }
}

class GetFlashcardByIdUseCase extends UseCase<Flashcard, String> {
  final FlashcardRepository repository;

  GetFlashcardByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Flashcard>> call(String id) {
    return repository.getFlashcardById(id);
  }
}

class SearchFlashcardsUseCase extends UseCase<List<Flashcard>, SearchFlashcardsParams> {
  final FlashcardRepository repository;

  SearchFlashcardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Flashcard>>> call(SearchFlashcardsParams params) {
    return repository.searchFlashcards(params.deckId, params.query);
  }
}

class CreateFlashcardUseCase extends UseCase<Flashcard, CreateFlashcardParams> {
  final FlashcardRepository repository;

  CreateFlashcardUseCase(this.repository);

  @override
  Future<Either<Failure, Flashcard>> call(CreateFlashcardParams params) async {
    final trimmedQuestion = params.question.trim();
    final trimmedAnswer = params.answer.trim();
    final trimmedHint = params.hint?.trim();

    final validationFailure = _validateFlashcard(trimmedQuestion, trimmedAnswer);
    if (validationFailure != null) return Left(validationFailure);

    return repository.createFlashcard(
      deckId: params.deckId,
      question: trimmedQuestion,
      answer: trimmedAnswer,
      hint: trimmedHint,
      type: params.type,
    );
  }
}

class UpdateFlashcardUseCase extends UseCase<Flashcard, UpdateFlashcardParams> {
  final FlashcardRepository repository;

  UpdateFlashcardUseCase(this.repository);

  @override
  Future<Either<Failure, Flashcard>> call(UpdateFlashcardParams params) async {
    final trimmedQuestion = params.question?.trim();
    final trimmedAnswer = params.answer?.trim();
    final trimmedHint = params.hint?.trim();

    final validationFailure = _validateFlashcard(
      trimmedQuestion,
      trimmedAnswer,
      allowNull: true,
    );
    if (validationFailure != null) return Left(validationFailure);

    return repository.updateFlashcard(
      id: params.id,
      question: trimmedQuestion,
      answer: trimmedAnswer,
      hint: trimmedHint,
      type: params.type,
    );
  }
}

class DeleteFlashcardUseCase extends UseCase<void, String> {
  final FlashcardRepository repository;

  DeleteFlashcardUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteFlashcard(id);
  }
}

class CreateFlashcardParams {
  final String deckId;
  final String question;
  final String answer;
  final String? hint;
  final FlashcardType type;

  const CreateFlashcardParams({
    required this.deckId,
    required this.question,
    required this.answer,
    this.hint,
    this.type = FlashcardType.vocabulary,
  });
}

class UpdateFlashcardParams {
  final String id;
  final String? question;
  final String? answer;
  final String? hint;
  final FlashcardType? type;

  const UpdateFlashcardParams({
    required this.id,
    this.question,
    this.answer,
    this.hint,
    this.type,
  });
}

class SearchFlashcardsParams {
  final String deckId;
  final String query;

  const SearchFlashcardsParams({
    required this.deckId,
    required this.query,
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
