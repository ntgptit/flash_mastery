import 'package:flash_mastery/core/error/failure_messages.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/domain/usecases/folders/folder_usecases.dart';
import 'package:flash_mastery/presentation/providers/folder_providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_view_model.freezed.dart';
part 'folder_view_model.g.dart';

@freezed
class FolderListState with _$FolderListState {
  const factory FolderListState.initial() = _Initial;
  const factory FolderListState.loading() = _Loading;
  const factory FolderListState.success(List<Folder> folders) = _Success;
  const factory FolderListState.error(String message) = _Error;
}

@riverpod
GetFoldersUseCase getFoldersUseCase(Ref ref) {
  return GetFoldersUseCase(ref.watch(folderRepositoryProvider));
}

@riverpod
CreateFolderUseCase createFolderUseCase(Ref ref) {
  return CreateFolderUseCase(ref.watch(folderRepositoryProvider));
}

@riverpod
UpdateFolderUseCase updateFolderUseCase(Ref ref) {
  return UpdateFolderUseCase(ref.watch(folderRepositoryProvider));
}

@riverpod
DeleteFolderUseCase deleteFolderUseCase(Ref ref) {
  return DeleteFolderUseCase(ref.watch(folderRepositoryProvider));
}

@riverpod
class FolderListViewModel extends _$FolderListViewModel {
  bool _initialized = false;

  @override
  FolderListState build() {
    _init();
    return const FolderListState.initial();
  }

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;
    await load();
  }

  Future<void> load() async {
    state = const FolderListState.loading();
    final result = await ref.read(getFoldersUseCaseProvider).call(const GetFoldersParams());
    state = result.fold(
      (failure) => FolderListState.error(failure.toDisplayMessage()),
      (folders) => FolderListState.success(folders),
    );
  }

  Future<String?> createFolder(CreateFolderParams params) async {
    state = const FolderListState.loading();
    final result = await ref.read(createFolderUseCaseProvider).call(params);
    final message = result.fold((failure) => failure.toDisplayMessage(), (_) => null);
    await load();
    return message;
  }

  Future<String?> updateFolder(UpdateFolderParams params) async {
    state = const FolderListState.loading();
    final result = await ref.read(updateFolderUseCaseProvider).call(params);
    final message = result.fold((failure) => failure.toDisplayMessage(), (_) => null);
    await load();
    return message;
  }

  Future<String?> deleteFolder(String id) async {
    state = const FolderListState.loading();
    final result = await ref.read(deleteFolderUseCaseProvider).call(id);
    final message = result.fold((failure) => failure.toDisplayMessage(), (_) => null);
    await load();
    return message;
  }
}
