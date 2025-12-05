import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/router/app_router.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/features/decks/providers.dart';
import 'package:flash_mastery/features/folders/providers.dart';
import 'package:flash_mastery/presentation/screens/decks/widgets/deck_form_dialog.dart';
import 'package:flash_mastery/presentation/screens/flashcards/flashcard_list_screen.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_breadcrumb.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_card.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_form_dialog.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeckListScreen extends ConsumerStatefulWidget {
  final Folder? folder;

  const DeckListScreen({super.key, this.folder});

  @override
  ConsumerState<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends ConsumerState<DeckListScreen> {
  static const String _defaultSort = 'latest';
  String _sort = _defaultSort;
  String _searchQuery = '';
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    Future.microtask(() {
      ref.read(folderListViewModelProvider.notifier).load();
      ref
          .read(deckListViewModelProvider(widget.folder?.id).notifier)
          .load(sort: _sort, query: _searchQuery.isEmpty ? null : _searchQuery);
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
    final subFolders = widget.folder == null
        ? <Folder>[]
        : folders.where((f) => f.parentId == widget.folder!.id).toList();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: deckListState.when(
          initial: () => const Center(child: LoadingWidget()),
          loading: () => const Center(child: LoadingWidget()),
          error: (message) => Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppErrorWidget(message: message, onRetry: _refreshWithDefaults),
          ),
          success: (decks, isLoadingMore, hasMore) {
            return RefreshIndicator(
              color: colorScheme.primary,
              onRefresh: () async => _refreshWithDefaults(),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.extentAfter < 200 && hasMore && !isLoadingMore) {
                    ref.read(deckListViewModelProvider(widget.folder?.id).notifier).loadMore();
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (widget.folder != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                child: FolderBreadcrumb(
                                  allFolders: folders,
                                  current: widget.folder!,
                                  onRootTap: () => context.goNamed('decks'),
                                  onFolderTap: (folder) => context.goNamed('decks', extra: folder),
                                ),
                              ),
                            _HeaderSection(
                              title: widget.folder?.name ?? 'Decks',
                              description:
                                  widget.folder?.description ?? 'Organize and review your decks',
                              onBack: _handleBack,
                              onSearch: _showSearchDialog,
                              onMenuSelect: (value) {
                                if (value == 'refresh') {
                                  _refreshWithDefaults();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: _SortRow(onTap: _showSortSheet, sortLabel: _sortLabel),
                      ),
                    ),
                    if (widget.folder != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          child: _SubfolderSection(
                            subfolders: subFolders,
                            onCreate: () => _openSubfolderForm(),
                            onOpen: (folder) => context.goNamed('decks', extra: folder),
                            onEdit: (folder) => _openSubfolderForm(folder: folder),
                            onDelete: _confirmDeleteFolder,
                            onAddSubfolder: (folder) => _openSubfolderForm(parent: folder),
                          ),
                        ),
                      ),
                    if (decks.isEmpty)
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
                            final deck = decks[index];
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
                          itemCount: decks.length,
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Center(
                          child: isLoadingMore
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : hasMore
                              ? const SizedBox(height: 24)
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDeckForm(folders: folders),
        icon: const Icon(Icons.add),
        label: const Text('New Deck'),
      ),
    );
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
            setState(() => _searchQuery = value);
            ref
                .read(deckListViewModelProvider(widget.folder?.id).notifier)
                .load(sort: _sort, query: _searchQuery);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              setState(() => _searchQuery = controller.text);
              ref
                  .read(deckListViewModelProvider(widget.folder?.id).notifier)
                  .load(sort: _sort, query: _searchQuery);
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

  Future<void> _openSubfolderForm({Folder? folder, Folder? parent}) async {
    final parentFolder = parent ?? widget.folder;
    if (parentFolder == null) return;
    await showDialog(
      context: context,
      builder: (context) => FolderFormDialog(
        folder: folder,
        parentFolder: parentFolder,
        onSubmit: (name, description, color, parentId) async {
          final navigator = Navigator.of(context);
          final messenger = ScaffoldMessenger.of(context);
          try {
            final notifier = ref.read(folderListViewModelProvider.notifier);
            final errorMessage = folder == null
                ? await notifier.createFolder(
                    CreateFolderParams(
                      name: name,
                      description: description,
                      color: color,
                      parentId: parentFolder.id,
                    ),
                  )
                : await notifier.updateFolder(
                    UpdateFolderParams(
                      id: folder.id,
                      name: name,
                      description: description,
                      color: color,
                      parentId: parentFolder.id,
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
                    folder == null ? 'Subfolder created successfully' : 'Subfolder updated',
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

  Future<void> _confirmDeleteFolder(Folder folder) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder'),
        content: SingleChildScrollView(
          child: Text(
            'Delete subfolder "${folder.name}"?\nThis will remove it from this folder.',
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

    if (!mounted || shouldDelete != true) return;

    try {
      final errorMessage =
          await ref.read(folderListViewModelProvider.notifier).deleteFolder(folder.id);
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

  String get _sortLabel {
    switch (_sort) {
      case 'name,asc':
        return 'Name (A-Z)';
      case 'name,desc':
        return 'Name (Z-A)';
      case 'cardCount,desc':
        return 'Cards (High-Low)';
      case 'cardCount,asc':
        return 'Cards (Low-High)';
      default:
        return 'Latest';
    }
  }

  Future<void> _refreshWithDefaults() async {
    setState(() => _sort = _defaultSort);
    await ref
        .read(deckListViewModelProvider(widget.folder?.id).notifier)
        .load(sort: _sort, query: _searchQuery.isEmpty ? null : _searchQuery);
  }

  void _showSortSheet() {
    final options = <Map<String, String>>[
      {'value': _defaultSort, 'label': 'Latest'},
      {'value': 'name,asc', 'label': 'Name (A-Z)'},
      {'value': 'name,desc', 'label': 'Name (Z-A)'},
      {'value': 'cardCount,desc', 'label': 'Cards (High-Low)'},
      {'value': 'cardCount,asc', 'label': 'Cards (Low-High)'},
    ];
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text('Sort decks', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            ...options.map(
              (opt) => ListTile(
                title: Text(opt['label']!),
                trailing: _sort == opt['value'] ? const Icon(Icons.check) : null,
                onTap: () {
                  setState(() => _sort = opt['value']!);
                  ref
                      .read(deckListViewModelProvider(widget.folder?.id).notifier)
                      .load(sort: _sort, query: _searchQuery.isEmpty ? null : _searchQuery);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _openDeck(Deck deck) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => FlashcardListScreen(deck: deck)));
  }

  void _handleBack() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
    context.go(AppRouter.dashboard);
  }
}

class _HeaderSection extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final void Function(String value) onMenuSelect;

  const _HeaderSection({
    required this.title,
    required this.description,
    required this.onBack,
    required this.onSearch,
    required this.onMenuSelect,
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
            IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back), tooltip: 'Back'),
            const Spacer(),
            IconButton(onPressed: onSearch, icon: const Icon(Icons.search), tooltip: 'Search'),
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
          child: Text(title, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
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
      ],
    );
  }
}

class _SubfolderSection extends StatelessWidget {
  final List<Folder> subfolders;
  final VoidCallback onCreate;
  final void Function(Folder folder) onOpen;
  final void Function(Folder folder) onEdit;
  final void Function(Folder folder) onDelete;
  final void Function(Folder folder)? onAddSubfolder;

  const _SubfolderSection({
    required this.subfolders,
    required this.onCreate,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    this.onAddSubfolder,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subfolders', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            TextButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.create_new_folder_outlined),
              label: const Text('New subfolder'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (subfolders.isEmpty)
          Card(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.folder_open_outlined, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'No subfolders yet. Create one to organize deeper.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: subfolders
                .map(
                  (folder) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: FolderTile(
                      folder: folder,
                      onTap: () => onOpen(folder),
                      onEdit: () => onEdit(folder),
                      onAddSubfolder:
                          onAddSubfolder != null ? () => onAddSubfolder!(folder) : null,
                      onDelete: () => onDelete(folder),
                      isGrid: false,
                      fixedColor: colorScheme.primary,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _SortRow extends StatelessWidget {
  final VoidCallback onTap;
  final String sortLabel;

  const _SortRow({required this.onTap, required this.sortLabel});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(sortLabel, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        IconButton(
          onPressed: onTap,
          icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
        ),
      ],
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
                    '${folder.name} - ${deck.cardCount} cards',
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
                  child: Text('Delete', style: TextStyle(color: colorScheme.error)),
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
