import 'package:flash_mastery/core/error/failure_messages.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/import_summary.dart';
import 'package:flash_mastery/domain/usecases/decks/deck_usecases.dart';
import 'package:flash_mastery/presentation/providers/deck_providers.dart';
import 'package:flash_mastery/presentation/viewmodels/folder_view_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deck_view_model.freezed.dart';
part 'deck_view_model.g.dart';

@freezed
class DeckListState with _$DeckListState {
  const factory DeckListState.initial() = _Initial;
  const factory DeckListState.loading() = _Loading;
  const factory DeckListState.success(
    List<Deck> decks, {
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
  }) = _Success;
  const factory DeckListState.error(String message) = _Error;
}

@riverpod
GetDecksUseCase getDecksUseCase(Ref ref) {
  return GetDecksUseCase(ref.watch(deckRepositoryProvider));
}

@riverpod
CreateDeckUseCase createDeckUseCase(Ref ref) {
  return CreateDeckUseCase(ref.watch(deckRepositoryProvider));
}

@riverpod
UpdateDeckUseCase updateDeckUseCase(Ref ref) {
  return UpdateDeckUseCase(ref.watch(deckRepositoryProvider));
}

@riverpod
DeleteDeckUseCase deleteDeckUseCase(Ref ref) {
  return DeleteDeckUseCase(ref.watch(deckRepositoryProvider));
}

@riverpod
ImportDecksUseCase importDecksUseCase(Ref ref) {
  return ImportDecksUseCase(ref.watch(deckRepositoryProvider));
}

@riverpod
class DeckListViewModel extends _$DeckListViewModel {
  bool _initialized = false;
  String? _currentSort;
  String? _currentQuery;
  int _page = 0;
  final int _pageSize = 20;
  List<Deck> _cache = [];
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  DeckListState build(String? folderId) {
    _init();
    return const DeckListState.initial();
  }

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;
    await load();
  }

  Future<void> load({String? sort, String? query, int? page}) async {
    if (_isLoadingMore) return;
    _currentSort = sort ?? _currentSort;
    _currentQuery = query ?? _currentQuery;
    _page = page ?? 0;
    _hasMore = true;
    _cache = [];
    _isLoadingMore = false;
    state = const DeckListState.loading();
    final result = await ref
        .read(getDecksUseCaseProvider)
        .call(
          GetDecksParams(
            folderId: folderId,
            sort: _currentSort,
            query: _currentQuery,
            page: _page,
            size: _pageSize,
          ),
        );
    state = result.fold(
      (failure) => DeckListState.error(failure.toDisplayMessage()),
      (decks) {
        _cache = decks;
        _hasMore = decks.length == _pageSize;
        return DeckListState.success(
          _cache,
          hasMore: _hasMore,
          isLoadingMore: false,
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    state = DeckListState.success(
      _cache,
      hasMore: _hasMore,
      isLoadingMore: true,
    );
    _page += 1;
    final result = await ref
        .read(getDecksUseCaseProvider)
        .call(
          GetDecksParams(
            folderId: folderId,
            sort: _currentSort,
            query: _currentQuery,
            page: _page,
            size: _pageSize,
          ),
        );
    result.fold(
      (failure) {
        _isLoadingMore = false;
        state = DeckListState.success(
          _cache,
          hasMore: _hasMore,
          isLoadingMore: false,
        );
      },
      (decks) {
        _cache = [..._cache, ...decks];
        _hasMore = decks.length == _pageSize;
        _isLoadingMore = false;
        state = DeckListState.success(
          _cache,
          hasMore: _hasMore,
          isLoadingMore: false,
        );
      },
    );
  }

  Future<String?> createDeck(CreateDeckParams params) async {
    state = const DeckListState.loading();
    final result = await ref.read(createDeckUseCaseProvider).call(params);
    final message = result.fold(
      (failure) => failure.toDisplayMessage(),
      (_) => null,
    );
    await load();
    await ref.read(folderListViewModelProvider.notifier).load();
    return message;
  }

  Future<String?> updateDeck(UpdateDeckParams params) async {
    state = const DeckListState.loading();
    final result = await ref.read(updateDeckUseCaseProvider).call(params);
    final message = result.fold(
      (failure) => failure.toDisplayMessage(),
      (_) => null,
    );
    await load();
    await ref.read(folderListViewModelProvider.notifier).load();
    return message;
  }

  Future<String?> deleteDeck(String id) async {
    state = const DeckListState.loading();
    final result = await ref.read(deleteDeckUseCaseProvider).call(id);
    final message = result.fold(
      (failure) => failure.toDisplayMessage(),
      (_) => null,
    );
    await load();
    await ref.read(folderListViewModelProvider.notifier).load();
    return message;
  }

  Future<(ImportSummary?, String?)> importDecks(ImportDecksParams params) async {
    final result = await ref.read(importDecksUseCaseProvider).call(params);
    return result.fold(
      (failure) => (null, failure.toDisplayMessage()),
      (summary) => (summary, null),
    );
  }
}
