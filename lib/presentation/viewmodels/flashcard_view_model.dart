import 'package:flash_mastery/core/error/failure_messages.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/usecases/flashcards/flashcard_usecases.dart';
import 'package:flash_mastery/presentation/providers/flashcard_providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flashcard_view_model.freezed.dart';
part 'flashcard_view_model.g.dart';

@freezed
class FlashcardListState with _$FlashcardListState {
  const factory FlashcardListState.initial() = _Initial;
  const factory FlashcardListState.loading() = _Loading;
  const factory FlashcardListState.success(List<Flashcard> flashcards) = _Success;
  const factory FlashcardListState.error(String message) = _Error;
}

@riverpod
GetFlashcardsUseCase getFlashcardsUseCase(Ref ref) {
  return GetFlashcardsUseCase(ref.watch(flashcardRepositoryProvider));
}

@riverpod
CreateFlashcardUseCase createFlashcardUseCase(Ref ref) {
  return CreateFlashcardUseCase(ref.watch(flashcardRepositoryProvider));
}

@riverpod
UpdateFlashcardUseCase updateFlashcardUseCase(Ref ref) {
  return UpdateFlashcardUseCase(ref.watch(flashcardRepositoryProvider));
}

@riverpod
DeleteFlashcardUseCase deleteFlashcardUseCase(Ref ref) {
  return DeleteFlashcardUseCase(ref.watch(flashcardRepositoryProvider));
}

@riverpod
class FlashcardListViewModel extends _$FlashcardListViewModel {
  @override
  FlashcardListState build(String deckId) {
    // Auto-load on initialization
    Future.microtask(() => load());
    return const FlashcardListState.initial();
  }

  Future<void> load() async {
    state = const FlashcardListState.loading();
    final result = await ref.read(getFlashcardsUseCaseProvider).call(deckId);
    state = result.fold(
      (failure) => FlashcardListState.error(failure.toDisplayMessage()),
      (cards) => FlashcardListState.success(cards),
    );
  }

  Future<String?> createFlashcard(CreateFlashcardParams params) async {
    state = const FlashcardListState.loading();
    final result = await ref.read(createFlashcardUseCaseProvider).call(params);
    final message = result.fold((failure) => failure.toDisplayMessage(), (_) => null);
    await load();
    return message;
  }

  Future<String?> updateFlashcard(UpdateFlashcardParams params) async {
    state = const FlashcardListState.loading();
    final result = await ref.read(updateFlashcardUseCaseProvider).call(params);
    final message = result.fold((failure) => failure.toDisplayMessage(), (_) => null);
    await load();
    return message;
  }

  Future<String?> deleteFlashcard(String id) async {
    state = const FlashcardListState.loading();
    final result = await ref.read(deleteFlashcardUseCaseProvider).call(id);
    final message = result.fold((failure) => failure.toDisplayMessage(), (_) => null);
    await load();
    return message;
  }
}
