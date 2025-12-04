import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/remote/flashcard_remote_data_source.dart';
import 'package:flash_mastery/data/models/flashcard_model.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/repositories/flashcard_repository.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardRemoteDataSource remoteDataSource;

  FlashcardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Flashcard>> createFlashcard({
    required String deckId,
    required String question,
    required String answer,
    String? hint,
  }) async {
    return ErrorGuard.run(() async {
      final card = FlashcardModel(
        id: '',
        deckId: deckId,
        question: question,
        answer: answer,
        hint: hint,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final created = await remoteDataSource.createFlashcard(deckId, card);
      return created.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteFlashcard(String id) async {
    return ErrorGuard.run(() async {
      await remoteDataSource.deleteFlashcard(id);
      return;
    });
  }

  @override
  Future<Either<Failure, Flashcard>> getFlashcardById(String id) async {
    return ErrorGuard.run(() async {
      final card = await remoteDataSource.getById(id);
      return card.toEntity();
    });
  }

  @override
  Future<Either<Failure, List<Flashcard>>> getFlashcards(String deckId) async {
    return ErrorGuard.run(() async {
      final cards = await remoteDataSource.getByDeck(deckId);
      return cards.map((c) => c.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<Flashcard>>> searchFlashcards(
    String deckId,
    String query,
  ) async {
    return ErrorGuard.run(() async {
      final cards = await remoteDataSource.getByDeck(deckId);
      if (query.isEmpty) return cards.map((c) => c.toEntity()).toList();
      final lower = query.toLowerCase();
      final filtered = cards
          .where((c) =>
              c.question.toLowerCase().contains(lower) ||
              c.answer.toLowerCase().contains(lower) ||
              (c.hint ?? '').toLowerCase().contains(lower))
          .toList();
      return filtered.map((c) => c.toEntity()).toList();
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
      final existing = await remoteDataSource.getById(id);
      final updated = existing.copyWith(
        question: question ?? existing.question,
        answer: answer ?? existing.answer,
        hint: hint ?? existing.hint,
      );
      final saved = await remoteDataSource.updateFlashcard(id, updated);
      return saved.toEntity();
    });
  }
}
