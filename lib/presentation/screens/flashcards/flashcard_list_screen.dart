import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/presentation/providers/flashcard_providers.dart';
import 'package:flash_mastery/presentation/screens/flashcards/widgets/flashcard_form_dialog.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';

class FlashcardListScreen extends ConsumerStatefulWidget {
  final Deck deck;

  const FlashcardListScreen({super.key, required this.deck});

  @override
  ConsumerState<FlashcardListScreen> createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends ConsumerState<FlashcardListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = ref.watch(flashcardListProvider(widget.deck.id));
    final filteredCards = _filterFlashcards(flashcardsAsync.asData?.value);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cards · ${widget.deck.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: flashcardsAsync.when(
          data: (cards) {
            final visibleCards = filteredCards ?? cards;
            if (visibleCards.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.style_outlined,
                title: 'No flashcards yet',
                message: 'Create flashcards to start practicing',
                actionButtonText: 'Create Flashcard',
                onAction: _openCreateDialog,
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  ref.read(flashcardListProvider(widget.deck.id).notifier).refresh(),
              child: ListView.separated(
                itemCount: visibleCards.length,
                separatorBuilder: (_, __) => const Divider(
                  height: AppSpacing.borderWidthThin,
                  thickness: AppSpacing.borderWidthThin,
                ),
                itemBuilder: (context, index) {
                  final card = visibleCards[index];
                  return _FlashcardTile(
                    card: card,
                    onEdit: () => _openEditDialog(card),
                    onDelete: () => _confirmDelete(card),
                  );
                },
              ),
            );
          },
          loading: () => const LoadingWidget(),
          error: (error, _) => AppErrorWidget(
            message: error.toString(),
            onRetry: () =>
                ref.read(flashcardListProvider(widget.deck.id).notifier).refresh(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Flashcard'),
      ),
    );
  }

  List<Flashcard>? _filterFlashcards(List<Flashcard>? cards) {
    if (cards == null) return null;
    if (_searchQuery.isEmpty) return cards;
    final lower = _searchQuery.toLowerCase();
    return cards
        .where((c) =>
            c.question.toLowerCase().contains(lower) ||
            c.answer.toLowerCase().contains(lower) ||
            (c.hint?.toLowerCase().contains(lower) ?? false))
        .toList();
  }

  void _showSearchDialog() {
    final controller = TextEditingController(text: _searchQuery);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Flashcards'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter keyword...',
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

  Future<void> _openCreateDialog() async {
    await _openFlashcardDialog();
  }

  Future<void> _openEditDialog(Flashcard card) async {
    await _openFlashcardDialog(card: card);
  }

  Future<void> _openFlashcardDialog({Flashcard? card}) async {
    await showDialog(
      context: context,
      builder: (context) => FlashcardFormDialog(
        flashcard: card,
        onSubmit: ({
          required String question,
          required String answer,
          String? hint,
        }) async {
          try {
            if (card == null) {
              await ref.read(flashcardListProvider(widget.deck.id).notifier).createFlashcard(
                    deckId: widget.deck.id,
                    question: question,
                    answer: answer,
                    hint: hint,
                  );
            } else {
              await ref.read(flashcardListProvider(widget.deck.id).notifier).updateFlashcard(
                    id: card.id,
                    question: question,
                    answer: answer,
                    hint: hint,
                  );
            }

            if (!mounted) return;
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(card == null ? 'Flashcard created' : 'Flashcard updated'),
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

  Future<void> _confirmDelete(Flashcard card) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Flashcard'),
        content: SingleChildScrollView(
          child: Text(
            'Are you sure you want to delete this flashcard?',
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
      await ref.read(flashcardListProvider(widget.deck.id).notifier).deleteFlashcard(card.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Flashcard deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}

class _FlashcardTile extends StatelessWidget {
  final Flashcard card;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FlashcardTile({
    required this.card,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        card.question,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.answer,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if ((card.hint ?? '').isNotEmpty)
            Text(
              'Hint: ${card.hint}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
            child: Row(
              children: [
                Icon(Icons.edit, size: AppSpacing.iconSmallMedium),
                SizedBox(width: AppSpacing.sm),
                Text('Edit'),
              ],
            ),
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
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flashcard detail not implemented yet')),
        );
      },
    );
  }
}
