import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/presentation/providers/deck_providers.dart';
import 'package:flash_mastery/presentation/providers/folder_providers.dart';
import 'package:flash_mastery/presentation/screens/decks/widgets/deck_form_dialog.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeckListScreen extends ConsumerStatefulWidget {
  final Folder? folder;

  const DeckListScreen({super.key, this.folder});

  @override
  ConsumerState<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends ConsumerState<DeckListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final folderList = ref.watch(folderListProvider);
    final deckListState = ref.watch(deckListProvider(widget.folder?.id));

    final folders = folderList.asData?.value ?? [];
    final filteredDecks = _filterDecks(deckListState.asData?.value);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder != null ? 'Decks in ${widget.folder!.name}' : 'Decks'),
        actions: [
          IconButton(
            onPressed: _showSearchDialog,
            icon: const Icon(Icons.search),
            tooltip: 'Search decks',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: deckListState.when(
          data: (decks) {
            final visibleDecks = filteredDecks ?? decks;

            if (visibleDecks.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.layers_outlined,
                title: 'No decks yet',
                message: 'Create a deck to start adding flashcards',
                actionButtonText: 'Create Deck',
                onAction: () => _openDeckForm(folders: folders),
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  ref.read(deckListProvider(widget.folder?.id).notifier).refresh(),
              child: ListView.separated(
                itemCount: visibleDecks.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final deck = visibleDecks[index];
                  return _DeckTile(
                    deck: deck,
                    folder: folders.firstWhere(
                      (f) => f.id == deck.folderId,
                      orElse: () =>
                          widget.folder ??
                          Folder(
                            id: 'unknown',
                            name: 'Unknown',
                            description: null,
                            color: null,
                            deckCount: 0,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                    ),
                    onEdit: () => _openDeckForm(deck: deck, folders: folders),
                    onDelete: () => _confirmDelete(deck),
                  );
                },
              ),
            );
          },
          loading: () => const LoadingWidget(),
          error: (error, _) => AppErrorWidget(
            message: error.toString(),
            onRetry: () => ref.read(deckListProvider(widget.folder?.id).notifier).refresh(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDeckForm(folders: folders),
        icon: const Icon(Icons.add),
        label: const Text('New Deck'),
      ),
    );
  }

  List<Deck>? _filterDecks(List<Deck>? decks) {
    if (decks == null) return null;
    if (_searchQuery.isEmpty) return decks;

    final lower = _searchQuery.toLowerCase();
    return decks
        .where(
          (deck) =>
              deck.name.toLowerCase().contains(lower) ||
              (deck.description?.toLowerCase().contains(lower) ?? false),
        )
        .toList();
  }

  void _showSearchDialog() {
    final controller = TextEditingController(text: _searchQuery);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Decks'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter deck name...',
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

  Future<void> _openDeckForm({Deck? deck, required List<Folder> folders}) async {
    if (folders.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Create a folder before adding decks')));
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => DeckFormDialog(
        deck: deck,
        folders: folders,
        initialFolderId: deck?.folderId ?? widget.folder?.id ?? folders.first.id,
        onSubmit: (name, description, folderId) async {
          try {
            if (deck == null) {
              await ref
                  .read(deckListProvider(widget.folder?.id).notifier)
                  .createDeck(name: name, description: description, folderId: folderId);
            } else {
              await ref
                  .read(deckListProvider(widget.folder?.id).notifier)
                  .updateDeck(
                    id: deck.id,
                    name: name,
                    description: description,
                    folderId: folderId,
                  );
            }

            if (!mounted) return;
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  deck == null ? 'Deck created successfully' : 'Deck updated successfully',
                ),
              ),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
          }
        },
      ),
    );
  }

  Future<void> _confirmDelete(Deck deck) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Deck'),
        content: Text(
          'Are you sure you want to delete "${deck.name}"?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    try {
      await ref.read(deckListProvider(widget.folder?.id).notifier).deleteDeck(deck.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deck deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}

class _DeckTile extends StatelessWidget {
  final Deck deck;
  final Folder folder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DeckTile({
    required this.deck,
    required this.folder,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
        child: const Icon(Icons.layers, color: Colors.white),
      ),
      title: Text(deck.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((deck.description ?? '').isNotEmpty)
            Text(deck.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
          Text(
            'Folder: ${folder.name} · ${deck.cardCount} cards',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            onEdit();
          } else if (value == 'delete') {
            onDelete();
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 8), Text('Edit')]),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 20, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Deck open not implemented yet')));
      },
    );
  }
}
