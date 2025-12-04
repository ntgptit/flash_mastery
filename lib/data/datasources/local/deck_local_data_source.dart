import 'package:drift/drift.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/data/local/app_database.dart';
import 'package:flash_mastery/data/models/deck_model.dart';
import 'package:uuid/uuid.dart';

/// Local data source for deck operations (Drift + SQLite).
abstract class DeckLocalDataSource {
  Future<List<DeckModel>> getDecks({String? folderId});
  Future<DeckModel> getDeckById(String id);
  Future<DeckModel> createDeck(DeckModel deck);
  Future<DeckModel> updateDeck(DeckModel deck);
  Future<void> deleteDeck(String id);
  Future<List<DeckModel>> searchDecks(String query, {String? folderId});
}

class DeckLocalDataSourceImpl implements DeckLocalDataSource {
  DeckLocalDataSourceImpl({required this.db});

  final AppDatabase db;
  final _uuid = const Uuid();

  @override
  Future<List<DeckModel>> getDecks({String? folderId}) async {
    final query = db.select(db.decks);
    if (folderId != null) {
      query.where((tbl) => tbl.folderId.equals(folderId));
    }
    final rows = await query.get();
    return rows.map(_mapRowToModel).toList();
  }

  @override
  Future<DeckModel> getDeckById(String id) async {
    final row = await (db.select(db.decks)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) throw const NotFoundException(message: 'Deck not found');
    return _mapRowToModel(row);
  }

  @override
  Future<DeckModel> createDeck(DeckModel deck) async {
    final now = DateTime.now();
    final newDeck = deck.copyWith(
      id: deck.id.isEmpty ? _uuid.v4() : deck.id,
      createdAt: now,
      updatedAt: now,
    );

    await db.into(db.decks).insert(
          DecksCompanion.insert(
            id: newDeck.id,
            name: newDeck.name,
            description: Value(newDeck.description),
            folderId: Value(newDeck.folderId),
            cardCount: Value(newDeck.cardCount),
            createdAt: newDeck.createdAt,
            updatedAt: newDeck.updatedAt,
          ),
        );
    return newDeck;
  }

  @override
  Future<DeckModel> updateDeck(DeckModel deck) async {
    final existing =
        await (db.select(db.decks)..where((tbl) => tbl.id.equals(deck.id))).getSingleOrNull();
    if (existing == null) throw const NotFoundException(message: 'Deck not found');

    final updated = deck.copyWith(updatedAt: DateTime.now());
    await (db.update(db.decks)..where((tbl) => tbl.id.equals(deck.id))).write(
      DecksCompanion(
        name: Value(updated.name),
        description: Value(updated.description),
        folderId: Value(updated.folderId),
        cardCount: Value(updated.cardCount),
        updatedAt: Value(updated.updatedAt),
      ),
    );
    return updated;
  }

  @override
  Future<void> deleteDeck(String id) async {
    final deleted = await (db.delete(db.decks)..where((tbl) => tbl.id.equals(id))).go();
    if (deleted == 0) throw const NotFoundException(message: 'Deck not found');
  }

  @override
  Future<List<DeckModel>> searchDecks(String query, {String? folderId}) async {
    final lower = query.toLowerCase();
    final selection = db.select(db.decks)
      ..where(
        (tbl) => tbl.name.lower().like('%$lower%') | tbl.description.lower().like('%$lower%'),
      );
    if (folderId != null) {
      selection.where((tbl) => tbl.folderId.equals(folderId));
    }
    final rows = await selection.get();
    return rows.map(_mapRowToModel).toList();
  }

  DeckModel _mapRowToModel(Deck row) => DeckModel(
        id: row.id,
        name: row.name,
        description: row.description,
        folderId: row.folderId,
        cardCount: row.cardCount,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
}
