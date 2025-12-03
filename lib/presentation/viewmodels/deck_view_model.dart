import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flash_mastery/core/error/failure_messages.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/features/decks/providers.dart';
import 'package:flash_mastery/presentation/viewmodels/folder_view_model.dart';

part 'deck_view_model.freezed.dart';
part 'deck_view_model.g.dart';

@freezed
class DeckListState with _$DeckListState {
  const factory DeckListState.initial() = _Initial;
  const factory DeckListState.loading() = _Loading;
  const factory DeckListState.success(List<Deck> decks) = _Success;
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
class DeckListViewModel extends _$DeckListViewModel {
  bool _initialized = false;

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

  Future<void> load() async {
    state = const DeckListState.loading();
    final result = await ref.read(getDecksUseCaseProvider).call(folderId);
    state = result.fold(
      (failure) => DeckListState.error(failure.toDisplayMessage()),
      (decks) => DeckListState.success(decks),
    );
  }

  Future<String?> createDeck(CreateDeckParams params) async {
    state = const DeckListState.loading();
    final result = await ref.read(createDeckUseCaseProvider).call(params);
    final message = result.fold((failure) => failure.toDisplayMessage(), (_) => null);
    await load();
    await ref.read(folderListViewModelProvider.notifier).load();
    return message;
  }

  Future<String?> updateDeck(UpdateDeckParams params) async {
    state = const DeckListState.loading();
    final result = await ref.read(updateDeckUseCaseProvider).call(params);
    final message = result.fold((failure) => failure.toDisplayMessage(), (_) => null);
    await load();
    await ref.read(folderListViewModelProvider.notifier).load();
    return message;
  }

  Future<String?> deleteDeck(String id) async {
    state = const DeckListState.loading();
    final result = await ref.read(deleteDeckUseCaseProvider).call(id);
    final message = result.fold((failure) => failure.toDisplayMessage(), (_) => null);
    await load();
    await ref.read(folderListViewModelProvider.notifier).load();
    return message;
  }
}
