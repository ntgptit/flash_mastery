import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/presentation/providers/folder_providers.dart';
import 'package:flash_mastery/presentation/screens/decks/deck_list_screen.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_card.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_form_dialog.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';

class FolderListScreen extends ConsumerStatefulWidget {
  const FolderListScreen({super.key});

  @override
  ConsumerState<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends ConsumerState<FolderListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(folderListProvider);
    final visibleFolders = _filterFolders(foldersAsync.asData?.value);

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
      body: foldersAsync.when(
        data: (folders) {
          final data = visibleFolders ?? folders;
          if (data.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.folder_outlined,
              title: 'No folders yet',
              message: 'Create your first folder to organize your decks',
              actionButtonText: 'Create Folder',
              onAction: () => _openFolderForm(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.read(folderListProvider.notifier).refresh(),
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppConstants.defaultGridCrossAxisCount,
                crossAxisSpacing: AppSpacing.lg,
                mainAxisSpacing: AppSpacing.lg,
                childAspectRatio: AppConstants.folderGridAspectRatio,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final folder = data[index];
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
        loading: () => const LoadingWidget(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.read(folderListProvider.notifier).refresh(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openFolderForm,
        icon: const Icon(Icons.add),
        label: const Text('New Folder'),
      ),
    );
  }

  List<Folder>? _filterFolders(List<Folder>? folders) {
    if (folders == null) return null;
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
            if (folder == null) {
              await ref.read(folderListProvider.notifier).createFolder(
                    name: name,
                    description: description,
                    color: color,
                  );
            } else {
              await ref.read(folderListProvider.notifier).updateFolder(
                    id: folder.id,
                    name: name,
                    description: description,
                    color: color,
                  );
            }

            if (!mounted) return;
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  folder == null ? 'Folder created successfully' : 'Folder updated successfully',
                ),
              ),
            );
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
      await ref.read(folderListProvider.notifier).deleteFolder(folder.id);
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
