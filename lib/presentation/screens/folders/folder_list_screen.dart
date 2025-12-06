import 'package:flash_mastery/core/constants/config/view_scopes.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/features/folders/providers.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_card.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_form_dialog.dart';
import 'package:flash_mastery/presentation/viewmodels/folder_view_mode.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FolderListScreen extends StatelessWidget {
  const FolderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FolderListScreenBody();
  }
}

class _FolderListScreenBody extends ConsumerStatefulWidget {
  const _FolderListScreenBody();

  @override
  ConsumerState<_FolderListScreenBody> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends ConsumerState<_FolderListScreenBody> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final folderState = ref.watch(folderListViewModelProvider(ViewScope.folders));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
        actions: [
          Consumer(
              builder: (context, ref, _) {
              final mode = ref.watch(folderViewModeProvider(ViewScope.folders));
              return IconButton(
                icon: Icon(mode == FolderViewMode.grid ? Icons.view_list_outlined : Icons.grid_view_outlined),
                tooltip: mode == FolderViewMode.grid ? 'Switch to list view' : 'Switch to grid view',
                onPressed: () => ref.read(folderViewModeProvider(ViewScope.folders).notifier).toggle(),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: _showSearchDialog),
        ],
      ),
      body: folderState.when(
        initial: () => const LoadingWidget(),
        loading: () => const LoadingWidget(),
        success: (data) {
          final mode = ref.watch(folderViewModeProvider(ViewScope.folders));
          final displayFolders = _filterFolders(data);
          if (displayFolders.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.folder_outlined,
              title: 'No folders yet',
              message: 'Create your first folder to organize your decks',
              actionButtonText: 'Create Folder',
              onAction: () => _openFolderForm(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.read(folderListViewModelProvider(ViewScope.folders).notifier).load(),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              layoutBuilder: (currentChild, previousChildren) =>
                  currentChild ?? const SizedBox.shrink(),
              child: mode == FolderViewMode.grid
                  ? GridView.builder(
                      key: const ValueKey('grid'),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: AppConstants.defaultGridCrossAxisCount,
                        crossAxisSpacing: AppSpacing.lg,
                        mainAxisSpacing: AppSpacing.lg,
                        childAspectRatio: AppConstants.folderGridAspectRatio,
                      ),
                      itemCount: displayFolders.length,
                      itemBuilder: (context, index) {
                        final folder = displayFolders[index];
                        return FolderTile(
                          key: ValueKey(folder.id),
                          folder: folder,
                          onTap: () => _openFolder(folder),
                          onEdit: () => _openFolderForm(folder: folder),
                          onAddSubfolder: () => _openFolderForm(parent: folder),
                          onDelete: () => _confirmDelete(folder),
                          isGrid: true,
                          fixedColor: Theme.of(context).colorScheme.primary,
                        );
                      },
                    )
                  : ListView.separated(
                    key: const ValueKey('list'),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: displayFolders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final folder = displayFolders[index];
                          return FolderTile(
                            key: ValueKey(folder.id),
                            folder: folder,
                            onTap: () => _openFolder(folder),
                            onEdit: () => _openFolderForm(folder: folder),
                            onAddSubfolder: () => _openFolderForm(parent: folder),
                            onDelete: () => _confirmDelete(folder),
                            isGrid: false,
                            fixedColor: Theme.of(context).colorScheme.primary,
                          );
                      },
                    ),
            ),
          );
        },
        error: (message) => AppErrorWidget(
          message: message,
          onRetry: () => ref.read(folderListViewModelProvider(ViewScope.folders).notifier).load(),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _openFolderForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Folder> _filterFolders(List<Folder> folders) {
    if (_searchQuery.isEmpty) return folders;

    final lower = _searchQuery.toLowerCase();
    return folders
        .where(
          (folder) =>
              folder.name.toLowerCase().contains(lower) ||
              (folder.description?.toLowerCase().contains(lower) ?? false),
        )
        .toList();
  }

  void _showSearchDialog() {
    final controller = TextEditingController(text: _searchQuery);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Folders'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter folder name...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onSubmitted: (value) {
            setState(() {
              _searchQuery = value;
            });
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              setState(() {
                _searchQuery = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Future<void> _openFolderForm({Folder? folder, Folder? parent}) async {
    await ref.read(folderListViewModelProvider(ViewScope.folders).notifier).load();
    if (!mounted) return;
    final allFolders = ref.read(folderListViewModelProvider(ViewScope.folders)).maybeWhen(
      success: (folders) => folders,
      orElse: () => <Folder>[],
    );
    await showDialog(
      context: context,
      builder: (context) => FolderFormDialog(
        folder: folder,
        parentFolder: parent,
        allFolders: allFolders,
        onSubmit: (name, description, color, parentId) async {
          final navigator = Navigator.of(context);
          final messenger = ScaffoldMessenger.of(context);
          try {
            final notifier = ref.read(folderListViewModelProvider(ViewScope.folders).notifier);
            final errorMessage = folder == null
                ? await notifier.createFolder(
                    CreateFolderParams(
                      name: name,
                      description: description,
                      color: color,
                      parentId: parent?.id ?? parentId,
                    ),
                  )
                : await notifier.updateFolder(
                    UpdateFolderParams(
                      id: folder.id,
                      name: name,
                      description: description,
                      color: color,
                      parentId: parent?.id ?? parentId ?? folder.parentId,
                    ),
                  );

            if (!mounted) return;
            navigator.pop();
            if (errorMessage != null) {
              messenger.showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
            } else {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    folder == null ? 'Folder created successfully' : 'Folder updated successfully',
                  ),
                ),
              );
            }
          } catch (e) {
            if (!mounted) return;
            messenger.showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
          }
        },
      ),
    );
  }

  Future<void> _confirmDelete(Folder folder) async {
    // Build warning message with counts
    final warnings = <String>[];
    if (folder.subFolderCount > 0) {
      warnings.add('${folder.subFolderCount} subfolder${folder.subFolderCount > 1 ? 's' : ''}');
    }
    if (folder.deckCount > 0) {
      warnings.add('${folder.deckCount} deck${folder.deckCount > 1 ? 's' : ''}');
    }

    final warningText = warnings.isEmpty
        ? ''
        : '\n\nThis folder contains:\n• ${warnings.join('\n• ')}\n\nAll contents will be permanently deleted.';

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder'),
        content: SingleChildScrollView(
          child: Text(
            'Are you sure you want to delete "${folder.name}"?$warningText\n\nThis action cannot be undone.',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (shouldDelete != true) return;

    try {
      final errorMessage = await ref
          .read(folderListViewModelProvider(ViewScope.folders).notifier)
          .deleteFolder(folder.id);
      if (errorMessage != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Folder deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _openFolder(Folder folder) {
    context.goNamed('decks', extra: folder);
  }
}
