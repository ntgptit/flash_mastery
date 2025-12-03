import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/domain/usecases/decks/deck_usecases.dart';
import 'package:flash_mastery/presentation/screens/decks/widgets/deck_form_dialog.dart';
import 'package:flash_mastery/presentation/screens/flashcards/flashcard_list_screen.dart';
import 'package:flash_mastery/presentation/viewmodels/deck_view_model.dart';
import 'package:flash_mastery/presentation/viewmodels/folder_view_model.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';

class DeckListScreen extends ConsumerStatefulWidget {
  final Folder? folder;

  const DeckListScreen({super.key, this.folder});

  @override
  ConsumerState<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends ConsumerState<DeckListScreen> {
  String _searchQuery = '';
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    Future.microtask(() {
      ref.read(folderListViewModelProvider.notifier).load();
      ref.read(deckListViewModelProvider(widget.folder?.id).notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final folderState = ref.watch(folderListViewModelProvider);
    final deckListState = ref.watch(deckListViewModelProvider(widget.folder?.id));

    final folders = folderState.when(
      initial: () => <Folder>[],
      loading: () => <Folder>[],
      success: (data) => data,
      error: (_) => <Folder>[],
    );
    final filteredDecks = deckListState.maybeWhen(
      success: (data) => _filterDecks(data),
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.folder != null ? 'Decks in ${widget.folder!.name}' : 'Decks',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: _showSearchDialog,
            icon: const Icon(Icons.search),
            tooltip: 'Search decks',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: deckListState.when(
          initial: () => const LoadingWidget(),
          loading: () => const LoadingWidget(),
          success: (decks) {
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
                  ref.read(deckListViewModelProvider(widget.folder?.id).notifier).load(),
              child: ListView.separated(
                itemCount: visibleDecks.length,
                separatorBuilder: (_, __) => const Divider(
                  height: AppSpacing.borderWidthThin,
                  thickness: AppSpacing.borderWidthThin,
                ),
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
                    onOpen: () => _openDeck(deck),
                  );
                },
              ),
            );
          },
          error: (message) => AppErrorWidget(
            message: message,
            onRetry: () =>
                ref.read(deckListViewModelProvider(widget.folder?.id).notifier).load(),
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
          final navigator = Navigator.of(context);
          final messenger = ScaffoldMessenger.of(context);
          try {
            final notifier = ref.read(deckListViewModelProvider(widget.folder?.id).notifier);
            final errorMessage = deck == null
                ? await notifier.createDeck(
                    CreateDeckParams(
                      name: name,
                      description: description,
                      folderId: folderId,
                    ),
                  )
                : await notifier.updateDeck(
                    UpdateDeckParams(
                      id: deck.id,
                      name: name,
                      description: description,
                      folderId: folderId,
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
                    deck == null ? 'Deck created successfully' : 'Deck updated successfully',
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

  Future<void> _confirmDelete(Deck deck) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Deck'),
        content: SingleChildScrollView(
          child: Text(
            'Are you sure you want to delete "${deck.name}"?\nThis action cannot be undone.',
            maxLines: AppConstants.confirmationDialogMaxLines,
            overflow: TextOverflow.ellipsis,
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
      final errorMessage =
          await ref.read(deckListViewModelProvider(widget.folder?.id).notifier).deleteDeck(
                deck.id,
              );
      if (errorMessage != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage')),
        );
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deck deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _openDeck(Deck deck) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FlashcardListScreen(deck: deck),
      ),
    );
  }
}

class _DeckTile extends StatelessWidget {
  final Deck deck;
  final Folder folder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onOpen;

  const _DeckTile({
    required this.deck,
    required this.folder,
    required this.onEdit,
    required this.onDelete,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: AppOpacity.low),
        child: const Icon(Icons.layers, color: Colors.white),
      ),
      title: Text(
        deck.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((deck.description ?? '').isNotEmpty)
            Text(deck.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
          Text(
            'Folder: ${folder.name} · ${deck.cardCount} cards',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
          PopupMenuItem(
            value: 'edit',
            child: Row(children: const [
              Icon(Icons.edit, size: AppSpacing.iconSmallMedium),
              SizedBox(width: AppSpacing.sm),
              Text('Edit')
            ]),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  size: AppSpacing.iconSmallMedium,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: onOpen,
    );
  }
}
