import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flash_mastery/data/datasources/flashcard_local_data_source.dart';
import 'package:flash_mastery/data/repositories/flashcard_repository_impl.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/repositories/flashcard_repository.dart';
import 'package:flash_mastery/presentation/providers/deck_providers.dart';

part 'flashcard_providers.g.dart';

// ==================== DATA SOURCE PROVIDER ====================

@riverpod
FlashcardLocalDataSource flashcardLocalDataSource(Ref ref) {
  return FlashcardLocalDataSourceImpl();
}

// ==================== REPOSITORY PROVIDER ====================

@riverpod
FlashcardRepository flashcardRepository(Ref ref) {
  return FlashcardRepositoryImpl(
    flashcardLocalDataSource: ref.watch(flashcardLocalDataSourceProvider),
    deckLocalDataSource: ref.watch(deckLocalDataSourceProvider),
  );
}

// ==================== STATE PROVIDERS ====================

/// Provider for fetching flashcards in a deck
@riverpod
class FlashcardList extends _$FlashcardList {
  @override
  Future<List<Flashcard>> build(String deckId) async {
    final repository = ref.watch(flashcardRepositoryProvider);
    final result = await repository.getFlashcards(deckId);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (flashcards) => flashcards,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(flashcardRepositoryProvider);
      final result = await repository.getFlashcards(deckId);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (flashcards) => flashcards,
      );
    });
  }

  Future<void> createFlashcard({
    required String deckId,
    required String question,
    required String answer,
    String? hint,
  }) async {
    final repository = ref.read(flashcardRepositoryProvider);
    final result = await repository.createFlashcard(
      deckId: deckId,
      question: question,
      answer: answer,
      hint: hint,
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) async => refresh(),
    );
  }

  Future<void> updateFlashcard({
    required String id,
    String? question,
    String? answer,
    String? hint,
  }) async {
    final repository = ref.read(flashcardRepositoryProvider);
    final result = await repository.updateFlashcard(
      id: id,
      question: question,
      answer: answer,
      hint: hint,
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) async => refresh(),
    );
  }

  Future<void> deleteFlashcard(String id) async {
    final repository = ref.read(flashcardRepositoryProvider);
    final result = await repository.deleteFlashcard(id);

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) async => refresh(),
    );
  }
}

// ==================== SINGLE FLASHCARD ====================

@riverpod
Future<Flashcard> flashcard(Ref ref, String id) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  final result = await repository.getFlashcardById(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (card) => card,
  );
}
