import '../../core/exceptions/exceptions.dart';
import '../models/deck_model.dart';

/// Local data source for deck operations (in-memory for now).
abstract class DeckLocalDataSource {
  Future<List<DeckModel>> getDecks({String? folderId});
  Future<DeckModel> getDeckById(String id);
  Future<DeckModel> createDeck(DeckModel deck);
  Future<DeckModel> updateDeck(DeckModel deck);
  Future<void> deleteDeck(String id);
  Future<List<DeckModel>> searchDecks(String query, {String? folderId});
}

class DeckLocalDataSourceImpl implements DeckLocalDataSource {
  final List<DeckModel> _decks = [];

  @override
  Future<List<DeckModel>> getDecks({String? folderId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (folderId == null) return List.from(_decks);
    return _decks.where((deck) => deck.folderId == folderId).toList();
  }

  @override
  Future<DeckModel> getDeckById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _decks.firstWhere(
      (deck) => deck.id == id,
      orElse: () => throw const NotFoundException(message: 'Deck not found'),
    );
  }

  @override
  Future<DeckModel> createDeck(DeckModel deck) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newDeck = deck.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _decks.add(newDeck);
    return newDeck;
  }

  @override
  Future<DeckModel> updateDeck(DeckModel deck) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _decks.indexWhere((d) => d.id == deck.id);
    if (index == -1) {
      throw const NotFoundException(message: 'Deck not found');
    }
    final updatedDeck = deck.copyWith(updatedAt: DateTime.now());
    _decks[index] = updatedDeck;
    return updatedDeck;
  }

  @override
  Future<void> deleteDeck(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _decks.indexWhere((d) => d.id == id);
    if (index == -1) {
      throw const NotFoundException(message: 'Deck not found');
    }
    _decks.removeAt(index);
  }

  @override
  Future<List<DeckModel>> searchDecks(String query, {String? folderId}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final source = await getDecks(folderId: folderId);
    if (query.isEmpty) return source;
    final lower = query.toLowerCase();
    return source
        .where((deck) =>
            deck.name.toLowerCase().contains(lower) ||
            (deck.description?.toLowerCase().contains(lower) ?? false))
        .toList();
  }
}
