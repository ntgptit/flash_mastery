import 'package:flash_mastery/core/constants/config/view_scopes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_view_mode.g.dart';

enum FolderViewMode { grid, list }

@Riverpod(keepAlive: false)
class FolderViewModeNotifier extends _$FolderViewModeNotifier {
  @override
  FolderViewMode build(ViewScope scope) => FolderViewMode.list;

  void toggle() {
    state = state == FolderViewMode.grid ? FolderViewMode.list : FolderViewMode.grid;
  }

  void set(FolderViewMode mode) => state = mode;
}
