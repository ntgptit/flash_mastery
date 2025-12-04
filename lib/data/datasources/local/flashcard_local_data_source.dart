import 'package:drift/drift.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/data/local/app_database.dart';
import 'package:flash_mastery/data/models/flashcard_model.dart';
import 'package:uuid/uuid.dart';

/// Local data source for flashcard operations (Drift + SQLite).
abstract class FlashcardLocalDataSource {
  Future<List<FlashcardModel>> getFlashcards(String deckId);
  Future<FlashcardModel> getFlashcardById(String id);
  Future<FlashcardModel> createFlashcard(FlashcardModel flashcard);
  Future<FlashcardModel> updateFlashcard(FlashcardModel flashcard);
  Future<void> deleteFlashcard(String id);
  Future<List<FlashcardModel>> searchFlashcards(String deckId, String query);
}

class FlashcardLocalDataSourceImpl implements FlashcardLocalDataSource {
  FlashcardLocalDataSourceImpl({required this.db});

  final AppDatabase db;
  final _uuid = const Uuid();

  @override
  Future<List<FlashcardModel>> getFlashcards(String deckId) async {
    final rows = await (db.select(db.flashcards)..where((tbl) => tbl.deckId.equals(deckId))).get();
    return rows.map(_mapRowToModel).toList();
  }

  @override
  Future<FlashcardModel> getFlashcardById(String id) async {
    final row =
        await (db.select(db.flashcards)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) throw const NotFoundException(message: 'Flashcard not found');
    return _mapRowToModel(row);
  }

  @override
  Future<FlashcardModel> createFlashcard(FlashcardModel flashcard) async {
    final now = DateTime.now();
      final card = flashcard.copyWith(
        id: flashcard.id.isEmpty ? _uuid.v4() : flashcard.id,
        createdAt: now,
        updatedAt: now,
      );

    await db.into(db.flashcards).insert(
          FlashcardsCompanion.insert(
            id: card.id,
            deckId: card.deckId,
            question: card.question,
            answer: card.answer,
            hint: Value(card.hint),
            createdAt: card.createdAt,
            updatedAt: card.updatedAt,
          ),
        );
    return card;
  }

  @override
  Future<FlashcardModel> updateFlashcard(FlashcardModel flashcard) async {
    final existing =
        await (db.select(db.flashcards)..where((tbl) => tbl.id.equals(flashcard.id)))
            .getSingleOrNull();
    if (existing == null) throw const NotFoundException(message: 'Flashcard not found');

      final updated = flashcard.copyWith(updatedAt: DateTime.now());
    await (db.update(db.flashcards)..where((tbl) => tbl.id.equals(flashcard.id))).write(
      FlashcardsCompanion(
        question: Value(updated.question),
        answer: Value(updated.answer),
        hint: Value(updated.hint),
        updatedAt: Value(updated.updatedAt),
      ),
    );
    return updated;
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    final deleted = await (db.delete(db.flashcards)..where((tbl) => tbl.id.equals(id))).go();
    if (deleted == 0) throw const NotFoundException(message: 'Flashcard not found');
  }

  @override
  Future<List<FlashcardModel>> searchFlashcards(String deckId, String query) async {
    final lower = query.toLowerCase();
    final rows = await (db.select(db.flashcards)
          ..where((tbl) => tbl.deckId.equals(deckId))
          ..where(
            (tbl) =>
                tbl.question.lower().like('%$lower%') |
                tbl.answer.lower().like('%$lower%') |
                tbl.hint.lower().like('%$lower%'),
          ))
        .get();
    return rows.map(_mapRowToModel).toList();
  }

  FlashcardModel _mapRowToModel(Flashcard row) => FlashcardModel(
        id: row.id,
        deckId: row.deckId,
        question: row.question,
        answer: row.answer,
        hint: row.hint,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
}
