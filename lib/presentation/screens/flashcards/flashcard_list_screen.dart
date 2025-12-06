import 'dart:math';

import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';
import 'package:flash_mastery/features/flashcards/providers.dart';
import 'package:flash_mastery/presentation/screens/flashcards/widgets/flashcard_action_list.dart';
import 'package:flash_mastery/presentation/screens/flashcards/widgets/flashcard_card_list.dart';
import 'package:flash_mastery/presentation/screens/flashcards/widgets/flashcard_form_dialog.dart';
import 'package:flash_mastery/presentation/screens/flashcards/widgets/flashcard_hero_carousel.dart';
import 'package:flash_mastery/presentation/screens/flashcards/widgets/flashcard_progress_overview.dart';
import 'package:flash_mastery/presentation/screens/flashcards/widgets/flashcard_section_header.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashcardListScreen extends ConsumerStatefulWidget {
  final Deck deck;

  const FlashcardListScreen({super.key, required this.deck});

  @override
  ConsumerState<FlashcardListScreen> createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends ConsumerState<FlashcardListScreen> {
  String _searchQuery = '';
  bool _initialized = false;
  int _visibleCount = 15;
  static const int _pageSize = 15;
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _pageController = PageController(viewportFraction: 0.88);
    Future.microtask(
      () => ref.read(flashcardListViewModelProvider(widget.deck.id).notifier).load(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsState = ref.watch(flashcardListViewModelProvider(widget.deck.id));
    final filteredCards = flashcardsState.maybeWhen(
      success: (cards) => _filterFlashcards(cards),
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Cards · ${widget.deck.name}', maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: _showSearchDialog)],
      ),
      body: flashcardsState.when(
        initial: () => const LoadingWidget(),
        loading: () => const LoadingWidget(),
        success: (cards) {
          final List<Flashcard> visibleCards = filteredCards ?? cards;
          if (visibleCards.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: EmptyStateWidget(
                icon: Icons.style_outlined,
                title: 'No flashcards yet',
                message: 'Create flashcards to start practicing',
                actionButtonText: 'Create Flashcard',
                onAction: _openCreateDialog,
              ),
            );
          }

          final total = visibleCards.length;
          final showCount = total <= 0 ? 0 : max(0, min(_visibleCount, total));
          final showCards = showCount == 0 ? <Flashcard>[] : visibleCards.take(showCount).toList();
          final hasMore = showCount < total;

          return RefreshIndicator(
            onRefresh: () async =>
                ref.read(flashcardListViewModelProvider(widget.deck.id).notifier).load(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlashcardHeroCarousel(
                      cards: showCards,
                      pageController: _pageController,
                      currentPage: _currentPage,
                      onPageChanged: (page) => setState(() => _currentPage = page),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FlashcardSectionHeader(
                      title: 'Section: ${widget.deck.name}',
                      subtitle:
                          '${visibleCards.length} cards${widget.deck.description != null ? ' • ${widget.deck.description}' : ''}',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                          child: const Icon(Icons.person, size: AppSpacing.iconSmallMedium),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shared deck',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${visibleCards.length} terms',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                          ),
                          child: Text(
                            widget.deck.type.label,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FlashcardActionList(
                      onCreate: _openCreateDialog,
                      onStudy: () {},
                      onTest: () {},
                      onMatch: () {},
                      onBlast: () {},
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FlashcardProgressOverview(total: total),
                    const SizedBox(height: AppSpacing.lg),
                    FlashcardCardList(
                      cards: showCards,
                      hasMore: hasMore,
                      onLoadMore: () {
                        final nextCount = min(_visibleCount + _pageSize, visibleCards.length);
                        setState(() => _visibleCount = nextCount);
                      },
                      onEdit: _openEditDialog,
                      onDelete: _confirmDelete,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          );
        },
        error: (message) => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppErrorWidget(
            message: message,
            onRetry: () => ref.read(flashcardListViewModelProvider(widget.deck.id).notifier).load(),
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
        .where(
          (c) =>
              c.question.toLowerCase().contains(lower) ||
              c.answer.toLowerCase().contains(lower) ||
              (c.hint?.toLowerCase().contains(lower) ?? false),
        )
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

  Future<void> _openCreateDialog() async {
    setState(() => _visibleCount = _pageSize);
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
        deckType: widget.deck.type,
        onSubmit: ({required String question, required String answer, String? hint, required FlashcardType type}) async {
          final navigator = Navigator.of(context);
          final messenger = ScaffoldMessenger.of(context);
          try {
            final notifier = ref.read(flashcardListViewModelProvider(widget.deck.id).notifier);
            final errorMessage = card == null
                ? await notifier.createFlashcard(
                    CreateFlashcardParams(
                      deckId: widget.deck.id,
                      question: question,
                      answer: answer,
                      hint: hint,
                      type: type,
                    ),
                  )
                : await notifier.updateFlashcard(
                    UpdateFlashcardParams(
                      id: card.id,
                      question: question,
                      answer: answer,
                      hint: hint,
                      type: type,
                    ),
                  );

            if (!mounted) return;
            navigator.pop();
            if (errorMessage != null) {
              messenger.showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
            } else {
              messenger.showSnackBar(
                SnackBar(content: Text(card == null ? 'Flashcard created' : 'Flashcard updated')),
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
          .read(flashcardListViewModelProvider(widget.deck.id).notifier)
          .deleteFlashcard(card.id);
      if (errorMessage != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Flashcard deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
