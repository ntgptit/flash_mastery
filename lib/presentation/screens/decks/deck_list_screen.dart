import 'package:file_picker/file_picker.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/router/app_router.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/features/decks/providers.dart';
import 'package:flash_mastery/features/folders/providers.dart';
import 'package:flash_mastery/presentation/screens/decks/widgets/deck_card.dart';
import 'package:flash_mastery/presentation/screens/decks/widgets/deck_form_dialog.dart';
import 'package:flash_mastery/presentation/screens/decks/widgets/deck_header_section.dart';
import 'package:flash_mastery/presentation/screens/decks/widgets/deck_sort_row.dart';
import 'package:flash_mastery/presentation/screens/decks/widgets/deck_subfolder_section.dart';
import 'package:flash_mastery/presentation/screens/flashcards/flashcard_list_screen.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_breadcrumb.dart';
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
                                  onRootTap: null,
                                  onFolderTap: (folder) => context.goNamed('decks', extra: folder),
                                ),
                              ),
                            DeckHeaderSection(
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
                        child: DeckSortRow(onTap: _showSortSheet, sortLabel: _sortLabel),
                      ),
                    ),
                    if (widget.folder != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: DeckSubfolderSection(
                          subfolders: subFolders,
                          onCreate: () => _openSubfolderForm(allFolders: folders),
                          onOpen: (folder) => context.goNamed('decks', extra: folder),
                          onEdit: (folder) => _openSubfolderForm(folder: folder, allFolders: folders),
                          onDelete: _confirmDeleteFolder,
                          onAddSubfolder: (folder) => _openSubfolderForm(parent: folder, allFolders: folders),
                        ),
                      ),
                    ),
                    if (widget.folder != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => _pickAndImport(widget.folder!, folders),
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Import decks'),
                            ),
                          ),
                        ),
                      ),
                    _buildDecksSliver(decks, folders),
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
        onSubmit: (name, description, folderId, type) async {
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
                      type: type,
                    ),
                  )
                : await notifier.updateDeck(
                    UpdateDeckParams(
                      id: deck.id,
                      name: name,
                      description: description,
                      folderId: folderId,
                      type: deck.type,
                    ),
                  );

            if (!mounted) return;
            navigator.pop();
            if (errorMessage != null) {
              messenger.showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
              return;
            }
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  deck == null ? 'Deck created successfully' : 'Deck updated successfully',
                ),
              ),
            );
          } catch (e) {
            if (!mounted) return;
            messenger.showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
          }
        },
      ),
    );
  }

  Future<void> _openSubfolderForm({Folder? folder, Folder? parent, List<Folder> allFolders = const []}) async {
    final parentFolder = parent ?? widget.folder;
    if (parentFolder == null) return;
    await ref.read(folderListViewModelProvider.notifier).load();
    if (!mounted) return;
    final folders = ref.read(folderListViewModelProvider).maybeWhen(
          success: (items) => items,
          orElse: () => allFolders,
        );
    await showDialog(
      context: context,
      builder: (context) => FolderFormDialog(
        folder: folder,
        parentFolder: parentFolder,
        allFolders: folders,
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
              return;
            }
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  folder == null ? 'Subfolder created successfully' : 'Subfolder updated',
                ),
              ),
            );
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

  Future<void> _pickAndImport(Folder folder, List<Folder> allFolders) async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'tsv', 'xlsx'],
    );
    if (picked == null || picked.files.isEmpty) return;
    final file = picked.files.first;
    if (!mounted) return;
    final selectedType = await _chooseType(context);
    if (selectedType == null) return;

    final notifier = ref.read(deckListViewModelProvider(folder.id).notifier);
    final (summary, error) = await notifier.importDecks(
      ImportDecksParams(folderId: folder.id, type: selectedType, file: file),
    );
    await notifier.load();
    await ref.read(folderListViewModelProvider.notifier).load();
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text('Import failed: $error')));
      return;
    }
    final errCount = summary?.errors.length ?? 0;
    messenger.showSnackBar(
      SnackBar(
        content: Text('Imported ${summary?.successCount ?? 0} rows${errCount > 0 ? ', errors: $errCount' : ''}'),
        action: errCount > 0
            ? SnackBarAction(
                label: 'Details',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Import errors'),
                      content: SizedBox(
                        width: 360,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: summary!.errors
                                .map((e) => Text('Row ${e.rowIndex}: ${e.message}'))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }

  Future<FlashcardType?> _chooseType(BuildContext context) async {
    FlashcardType temp = FlashcardType.vocabulary;
    return showDialog<FlashcardType>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select flashcard type'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: FlashcardType.values
                .map(
                  (t) => ListTile(
                        leading: Icon(
                          temp == t ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(t == FlashcardType.vocabulary ? 'Vocabulary' : 'Grammar'),
                        onTap: () => setState(() => temp = t),
                      ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, temp), child: const Text('Import')),
        ],
      ),
    );
  }

  void _handleBack() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
    context.go(AppRouter.dashboard);
  }

  Widget _buildDecksSliver(List<Deck> decks, List<Folder> folders) {
    Widget sliver = SliverPadding(
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
                  level: 0,
                  path: const [],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
          );
          return DeckCard(
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
    );

    if (decks.isEmpty) {
      sliver = SliverToBoxAdapter(
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
      );
    }

    return sliver;
  }
}
