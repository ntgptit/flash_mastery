import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/presentation/providers/folder_providers.dart';
import 'package:flash_mastery/presentation/screens/decks/deck_list_screen.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_card.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_form_dialog.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(folderListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: AppSpacing.elevationNone,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            tooltip: 'Manage decks',
            onPressed: _openAllDecks,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Searching for: "$_searchQuery"',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: foldersAsync.when(
              data: (folders) {
                if (folders.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.folder_outlined,
                    title: 'No folders yet',
                    message: 'Create your first folder to organize your decks',
                    actionButtonText: 'Create Folder',
                    onAction: () => _showAddFolderDialog(context),
                  );
                }

                final filteredFolders = _searchQuery.isEmpty
                    ? folders
                    : folders
                        .where((folder) =>
                            folder.name
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()) ||
                            (folder.description
                                    ?.toLowerCase()
                                    .contains(_searchQuery.toLowerCase()) ??
                                false))
                        .toList();

                if (filteredFolders.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.search_off,
                    title: 'No results found',
                    message: 'Try searching with different keywords',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(folderListProvider.notifier).refresh();
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: AppConstants.defaultGridCrossAxisCount,
                      crossAxisSpacing: AppSpacing.lg,
                      mainAxisSpacing: AppSpacing.lg,
                      childAspectRatio: AppConstants.folderGridAspectRatio,
                    ),
                    itemCount: filteredFolders.length,
                    itemBuilder: (context, index) {
                      final folder = filteredFolders[index];
                      return FolderCard(
                        folder: folder,
                        onTap: () => _openFolder(folder),
                        onEdit: () => _showEditFolderDialog(context, folder),
                        onDelete: () => _showDeleteConfirmation(context, folder),
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, stack) => AppErrorWidget(
                message: error.toString(),
                onRetry: () {
                  ref.invalidate(folderListProvider);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFolderDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Folder'),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Folders'),
        content: TextField(
          controller: _searchController,
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
                _searchQuery = _searchController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FolderFormDialog(
        onSubmit: (name, description, color) async {
          try {
            await ref.read(folderListProvider.notifier).createFolder(
                  name: name,
                  description: description,
                  color: color,
                );
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Folder created successfully')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
          }
        },
      ),
    );
  }

  void _showEditFolderDialog(BuildContext context, Folder folder) {
    showDialog(
      context: context,
      builder: (context) => FolderFormDialog(
        folder: folder,
        onSubmit: (name, description, color) async {
          try {
            await ref.read(folderListProvider.notifier).updateFolder(
                  id: folder.id,
                  name: name,
                  description: description,
                  color: color,
                );
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Folder updated successfully')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Folder folder) {
    showDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ref.read(folderListProvider.notifier).deleteFolder(folder.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Folder deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openFolder(Folder folder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DeckListScreen(folder: folder),
      ),
    );
  }

  void _openAllDecks() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const DeckListScreen(),
      ),
    );
  }
}
