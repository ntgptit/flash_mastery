import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/data/models/flashcard_model.dart';

/// Local data source for flashcard operations (in-memory for now).
abstract class FlashcardLocalDataSource {
  Future<List<FlashcardModel>> getFlashcards(String deckId);
  Future<FlashcardModel> getFlashcardById(String id);
  Future<FlashcardModel> createFlashcard(FlashcardModel flashcard);
  Future<FlashcardModel> updateFlashcard(FlashcardModel flashcard);
  Future<void> deleteFlashcard(String id);
  Future<List<FlashcardModel>> searchFlashcards(String deckId, String query);
}

class FlashcardLocalDataSourceImpl implements FlashcardLocalDataSource {
  final List<FlashcardModel> _flashcards = [];

  @override
  Future<List<FlashcardModel>> getFlashcards(String deckId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _flashcards.where((card) => card.deckId == deckId).toList();
  }

  @override
  Future<FlashcardModel> getFlashcardById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _flashcards.firstWhere(
      (card) => card.id == id,
      orElse: () => throw const NotFoundException(message: 'Flashcard not found'),
    );
  }

  @override
  Future<FlashcardModel> createFlashcard(FlashcardModel flashcard) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newCard = flashcard.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _flashcards.add(newCard);
    return newCard;
  }

  @override
  Future<FlashcardModel> updateFlashcard(FlashcardModel flashcard) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _flashcards.indexWhere((c) => c.id == flashcard.id);
    if (index == -1) {
      throw const NotFoundException(message: 'Flashcard not found');
    }
    final updated = flashcard.copyWith(updatedAt: DateTime.now());
    _flashcards[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _flashcards.indexWhere((c) => c.id == id);
    if (index == -1) {
      throw const NotFoundException(message: 'Flashcard not found');
    }
    _flashcards.removeAt(index);
  }

  @override
  Future<List<FlashcardModel>> searchFlashcards(String deckId, String query) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final source = await getFlashcards(deckId);
    if (query.isEmpty) return source;
    final lower = query.toLowerCase();
    return source
        .where((card) =>
            card.question.toLowerCase().contains(lower) ||
            card.answer.toLowerCase().contains(lower) ||
            (card.hint?.toLowerCase().contains(lower) ?? false))
        .toList();
  }
}
