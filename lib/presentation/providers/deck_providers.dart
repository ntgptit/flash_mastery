import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/deck_local_data_source.dart';
import '../../data/repositories/deck_repository_impl.dart';
import '../../domain/entities/deck.dart';
import '../../domain/repositories/deck_repository.dart';
import 'folder_providers.dart';

part 'deck_providers.g.dart';

// ==================== DATA SOURCE PROVIDER ====================

@riverpod
DeckLocalDataSource deckLocalDataSource(Ref ref) {
  return DeckLocalDataSourceImpl();
}

// ==================== REPOSITORY PROVIDER ====================

@riverpod
DeckRepository deckRepository(Ref ref) {
  return DeckRepositoryImpl(
    deckLocalDataSource: ref.watch(deckLocalDataSourceProvider),
    folderLocalDataSource: ref.watch(folderLocalDataSourceProvider),
  );
}

// ==================== STATE PROVIDERS ====================

/// Provider for fetching decks (optionally filtered by folder).
@riverpod
class DeckList extends _$DeckList {
  @override
  Future<List<Deck>> build(String? folderId) async {
    final repository = ref.watch(deckRepositoryProvider);
    final result = await repository.getDecks(folderId: folderId);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (decks) => decks,
    );
  }

  /// Refresh deck list.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(deckRepositoryProvider);
      final result = await repository.getDecks(folderId: folderId);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (decks) => decks,
      );
    });
  }

  /// Create new deck.
  Future<void> createDeck({
    required String name,
    String? description,
    String? folderId,
  }) async {
    final repository = ref.read(deckRepositoryProvider);
    final targetFolderId = folderId ?? this.folderId;

    final result = await repository.createDeck(
      name: name,
      description: description,
      folderId: targetFolderId,
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) async {
        await refresh();
        await _refreshFolders();
      },
    );
  }

  /// Update deck.
  Future<void> updateDeck({
    required String id,
    String? name,
    String? description,
    String? folderId,
  }) async {
    final repository = ref.read(deckRepositoryProvider);
    final targetFolderId = folderId ?? this.folderId;

    final result = await repository.updateDeck(
      id: id,
      name: name,
      description: description,
      folderId: targetFolderId,
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) async {
        await refresh();
        await _refreshFolders();
      },
    );
  }

  /// Delete deck.
  Future<void> deleteDeck(String id) async {
    final repository = ref.read(deckRepositoryProvider);
    final result = await repository.deleteDeck(id);

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) async {
        await refresh();
        await _refreshFolders();
      },
    );
  }

  Future<void> _refreshFolders() async {
    final foldersNotifier = ref.read(folderListProvider.notifier);
    await foldersNotifier.refresh();
  }
}

// ==================== SINGLE DECK PROVIDER ====================

@riverpod
Future<Deck> deck(Ref ref, String id) async {
  final repository = ref.watch(deckRepositoryProvider);
  final result = await repository.getDeckById(id);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (deck) => deck,
  );
}

// ==================== SEARCH PROVIDER ====================

@riverpod
class DeckSearch extends _$DeckSearch {
  @override
  Future<List<Deck>> build(String query) async {
    if (query.isEmpty) {
      final decks = ref.watch(deckListProvider(null)).value;
      return decks ?? [];
    }

    final repository = ref.watch(deckRepositoryProvider);
    final result = await repository.searchDecks(query);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (decks) => decks,
    );
  }
}
