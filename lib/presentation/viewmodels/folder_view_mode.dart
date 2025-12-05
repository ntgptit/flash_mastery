import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_view_mode.g.dart';

enum FolderViewMode { grid, list }

@Riverpod(keepAlive: true)
class FolderViewModeNotifier extends _$FolderViewModeNotifier {
  @override
  FolderViewMode build() => FolderViewMode.list;

  void toggle() {
    state = state == FolderViewMode.grid ? FolderViewMode.list : FolderViewMode.grid;
  }

  void set(FolderViewMode mode) => state = mode;
}
