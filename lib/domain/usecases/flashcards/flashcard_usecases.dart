import 'package:dartz/dartz.dart';

import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/repositories/flashcard_repository.dart';

class GetFlashcardsUseCase {
  final FlashcardRepository repository;

  const GetFlashcardsUseCase(this.repository);

  Future<Either<Failure, List<Flashcard>>> call(String deckId) {
    return repository.getFlashcards(deckId);
  }
}

class CreateFlashcardUseCase {
  final FlashcardRepository repository;

  const CreateFlashcardUseCase(this.repository);

  Future<Either<Failure, Flashcard>> call(CreateFlashcardParams params) {
    return repository.createFlashcard(
      deckId: params.deckId,
      question: params.question,
      answer: params.answer,
      hint: params.hint,
    );
  }
}

class UpdateFlashcardUseCase {
  final FlashcardRepository repository;

  const UpdateFlashcardUseCase(this.repository);

  Future<Either<Failure, Flashcard>> call(UpdateFlashcardParams params) {
    return repository.updateFlashcard(
      id: params.id,
      question: params.question,
      answer: params.answer,
      hint: params.hint,
    );
  }
}

class DeleteFlashcardUseCase {
  final FlashcardRepository repository;

  const DeleteFlashcardUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteFlashcard(id);
  }
}

class CreateFlashcardParams {
  final String deckId;
  final String question;
  final String answer;
  final String? hint;

  const CreateFlashcardParams({
    required this.deckId,
    required this.question,
    required this.answer,
    this.hint,
  });
}

class UpdateFlashcardParams {
  final String id;
  final String? question;
  final String? answer;
  final String? hint;

  const UpdateFlashcardParams({
    required this.id,
    this.question,
    this.answer,
    this.hint,
  });
}
