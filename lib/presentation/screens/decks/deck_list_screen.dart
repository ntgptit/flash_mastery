import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/features/decks/providers.dart';
import 'package:flash_mastery/features/folders/providers.dart';
import 'package:flash_mastery/presentation/screens/decks/widgets/deck_form_dialog.dart';
import 'package:flash_mastery/presentation/screens/flashcards/flashcard_list_screen.dart';
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
  String _selectedFilter = 'all';
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

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: deckListState.when(
          initial: () => const Center(child: LoadingWidget()),
          loading: () => const Center(child: LoadingWidget()),
          error: (message) => Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppErrorWidget(
              message: message,
              onRetry: () =>
                  ref.read(deckListViewModelProvider(widget.folder?.id).notifier).load(),
            ),
          ),
          success: (decks) {
            final visibleDecks = filteredDecks ?? decks;

            return RefreshIndicator(
              color: colorScheme.primary,
              onRefresh: () async =>
                  ref.read(deckListViewModelProvider(widget.folder?.id).notifier).load(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.lg,
                      ),
                      child: _HeaderSection(
                        title: widget.folder?.name ?? 'Decks',
                        description:
                            widget.folder?.description ?? 'Organize and review your decks',
                        onBack: Navigator.of(context).maybePop,
                        onAdd: () => _openDeckForm(folders: folders),
                        onSearch: _showSearchDialog,
                        onMenuSelect: (value) {
                          if (value == 'refresh') {
                            ref.read(deckListViewModelProvider(widget.folder?.id).notifier).load();
                          }
                        },
                        onFilterChanged: (value) {
                          setState(() {
                            _selectedFilter = value;
                          });
                        },
                        selectedFilter: _selectedFilter,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: _SortRow(onTap: () {}),
                    ),
                  ),
                  if (visibleDecks.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: EmptyStateWidget(
                          icon: Icons.layers_outlined,
                          title: 'No decks yet',
                          message: 'Create a deck to start adding flashcards',
                          actionButtonText: 'Create Deck',
                          onAction: () => _openDeckForm(folders: folders),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.lg,
                      ),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) {
                          final deck = visibleDecks[index];
                          final folder = folders.firstWhere(
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
                          );
                          return _DeckCard(
                            deck: deck,
                            folder: folder,
                            onOpen: () => _openDeck(deck),
                            onEdit: () => _openDeckForm(deck: deck, folders: folders),
                            onDelete: () => _confirmDelete(deck),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                        itemCount: visibleDecks.length,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
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
                    CreateDeckParams(name: name, description: description, folderId: folderId),
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
      final errorMessage = await ref
          .read(deckListViewModelProvider(widget.folder?.id).notifier)
          .deleteDeck(deck.id);
      if (errorMessage != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deck deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _openDeck(Deck deck) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => FlashcardListScreen(deck: deck)));
  }
}

class _HeaderSection extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onBack;
  final VoidCallback onAdd;
  final VoidCallback onSearch;
  final void Function(String value) onMenuSelect;
  final void Function(String value) onFilterChanged;
  final String selectedFilter;

  const _HeaderSection({
    required this.title,
    required this.description,
    required this.onBack,
    required this.onAdd,
    required this.onSearch,
    required this.onMenuSelect,
    required this.onFilterChanged,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
            ),
            const Spacer(),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              tooltip: 'Create deck',
            ),
            IconButton(
              onPressed: onSearch,
              icon: const Icon(Icons.search),
              tooltip: 'Search',
            ),
            PopupMenuButton<String>(
              onSelected: onMenuSelect,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'refresh', child: Text('Refresh')),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: AppOpacity.low),
              borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
            ),
            child: Icon(Icons.folder, color: colorScheme.onPrimary, size: AppSpacing.iconLarge),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: Text(
            title,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Text(
            description,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          alignment: WrapAlignment.center,
          children: [
            _FilterChip(
              label: '모두',
              selected: selectedFilter == 'all',
              onSelected: () => onFilterChanged('all'),
            ),
            _FilterChip(
              label: '+ 새 태그',
              selected: selectedFilter == 'tag',
              onSelected: () => onFilterChanged('tag'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _SortRow extends StatelessWidget {
  final VoidCallback onTap;

  const _SortRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text('Latest', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        IconButton(
          onPressed: onTap,
          icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        child: Text(label),
      ),
      selected: selected,
      onSelected: (_) => onSelected(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        side: BorderSide(
          color: selected ? Colors.transparent : colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      selectedColor: colorScheme.primary.withValues(alpha: 0.15),
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      labelStyle: TextStyle(
        color: selected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DeckCard extends StatelessWidget {
  final Deck deck;
  final Folder folder;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DeckCard({
    required this.deck,
    required this.folder,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
      onTap: onOpen,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: AppOpacity.low),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              ),
              child: Icon(Icons.style, color: colorScheme.onPrimary, size: AppSpacing.iconMedium),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deck.name,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    (deck.description ?? 'No description'),
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${folder.name} · ${deck.cardCount} cards',
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'open') {
                  onOpen();
                } else if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'open', child: Text('Open')),
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete',
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
