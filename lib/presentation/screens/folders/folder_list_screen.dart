import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/domain/usecases/folders/folder_usecases.dart';
import 'package:flash_mastery/presentation/screens/decks/deck_list_screen.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_card.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_form_dialog.dart';
import 'package:flash_mastery/presentation/viewmodels/folder_view_model.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';

class FolderListScreen extends ConsumerStatefulWidget {
  const FolderListScreen({super.key});

  @override
  ConsumerState<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends ConsumerState<FolderListScreen> {
  String _searchQuery = '';
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    Future.microtask(() => ref.read(folderListViewModelProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final folderState = ref.watch(folderListViewModelProvider);
    final folders = folderState.when(
      initial: () => <Folder>[],
      loading: () => <Folder>[],
      success: (data) => data,
      error: (_) => <Folder>[],
    );
    final visibleFolders = _filterFolders(folders);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: folderState.when(
        initial: () => const LoadingWidget(),
        loading: () => const LoadingWidget(),
        success: (data) {
          final displayFolders = visibleFolders ?? data;
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
            onRefresh: () async => ref.read(folderListViewModelProvider.notifier).load(),
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppConstants.defaultGridCrossAxisCount,
                crossAxisSpacing: AppSpacing.lg,
                mainAxisSpacing: AppSpacing.lg,
                childAspectRatio: AppConstants.folderGridAspectRatio,
              ),
              itemCount: displayFolders.length,
              itemBuilder: (context, index) {
                final folder = displayFolders[index];
                return FolderCard(
                  folder: folder,
                  onTap: () => _openFolder(folder),
                  onEdit: () => _openFolderForm(folder: folder),
                  onDelete: () => _confirmDelete(folder),
                );
              },
            ),
          );
        },
        error: (message) => AppErrorWidget(
          message: message,
          onRetry: () => ref.read(folderListViewModelProvider.notifier).load(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openFolderForm,
        icon: const Icon(Icons.add),
        label: const Text('New Folder'),
      ),
    );
  }

  List<Folder>? _filterFolders(List<Folder> folders) {
    if (_searchQuery.isEmpty) return folders;

    final lower = _searchQuery.toLowerCase();
    return folders
        .where((folder) =>
            folder.name.toLowerCase().contains(lower) ||
            (folder.description?.toLowerCase().contains(lower) ?? false))
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
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

  Future<void> _openFolderForm({Folder? folder}) async {
    await showDialog(
      context: context,
      builder: (context) => FolderFormDialog(
        folder: folder,
        onSubmit: (name, description, color) async {
          try {
            final notifier = ref.read(folderListViewModelProvider.notifier);
            final errorMessage = folder == null
                ? await notifier.createFolder(
                    CreateFolderParams(
                      name: name,
                      description: description,
                      color: color,
                    ),
                  )
                : await notifier.updateFolder(
                    UpdateFolderParams(
                      id: folder.id,
                      name: name,
                      description: description,
                      color: color,
                    ),
                  );

            if (!mounted) return;
            Navigator.pop(context);
            if (errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $errorMessage')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    folder == null ? 'Folder created successfully' : 'Folder updated successfully',
                  ),
                ),
              );
            }
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.toString()}')),
            );
          }
        },
      ),
    );
  }

  Future<void> _confirmDelete(Folder folder) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder'),
        content: SingleChildScrollView(
          child: Text(
            'Are you sure you want to delete "${folder.name}"?\nThis action cannot be undone.',
            maxLines: AppConstants.confirmationDialogMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
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

    if (shouldDelete != true) return;

    try {
      final errorMessage =
          await ref.read(folderListViewModelProvider.notifier).deleteFolder(folder.id);
      if (errorMessage != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage')),
        );
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Folder deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _openFolder(Folder folder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DeckListScreen(folder: folder),
      ),
    );
  }
}
