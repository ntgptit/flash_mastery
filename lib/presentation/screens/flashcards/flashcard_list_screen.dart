import 'dart:math';

import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';
import 'package:flash_mastery/features/flashcards/providers.dart';
import 'package:flash_mastery/presentation/screens/flashcards/widgets/flashcard_form_dialog.dart';
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
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0B1022), Color(0xFF0F1530)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    _HeroCarousel(
                      cards: showCards,
                      pageController: _pageController,
                      currentPage: _currentPage,
                      onPageChanged: (page) => setState(() => _currentPage = page),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _SectionHeader(
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
                            'Vocabulary · Grammar',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ActionList(
                      onCreate: _openCreateDialog,
                      onStudy: () {},
                      onTest: () {},
                      onMatch: () {},
                      onBlast: () {},
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ProgressOverview(total: total),
                    const SizedBox(height: AppSpacing.lg),
                    _CardList(
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

class _TypeChip extends StatelessWidget {
  final FlashcardType type;

  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final isVocab = type == FlashcardType.vocabulary;
    final colorScheme = Theme.of(context).colorScheme;
    final bg = isVocab
        ? colorScheme.primary.withValues(alpha: AppOpacity.low)
        : colorScheme.secondary.withValues(alpha: AppOpacity.low);
    final fg = isVocab ? colorScheme.primary : colorScheme.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Text(
        isVocab ? 'Vocabulary' : 'Grammar',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _HeroCarousel extends StatelessWidget {
  final List<Flashcard> cards;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _HeroCarousel({
    required this.cards,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: pageController,
            itemCount: cards.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Center(
                    child: Text(
                      card.question,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(cards.length, (i) {
            final isActive = i == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 10 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ActionList extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onStudy;
  final VoidCallback onTest;
  final VoidCallback onMatch;
  final VoidCallback onBlast;

  const _ActionList({
    required this.onCreate,
    required this.onStudy,
    required this.onTest,
    required this.onMatch,
    required this.onBlast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionTile(
          icon: Icons.folder_open,
          title: 'Flashcards',
          onTap: onCreate,
        ),
        _ActionTile(
          icon: Icons.school_outlined,
          title: 'Study',
          onTap: onStudy,
        ),
        _ActionTile(
          icon: Icons.check_circle_outline,
          title: 'Test',
          onTap: onTest,
        ),
        _ActionTile(
          icon: Icons.view_agenda_outlined,
          title: 'Match',
          onTap: onMatch,
        ),
        _ActionTile(
          icon: Icons.rocket_launch_outlined,
          title: 'Blast',
          onTap: onBlast,
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          ),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressOverview extends StatelessWidget {
  final int total;

  const _ProgressOverview({required this.total});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your progress', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        _ProgressCard(
          title: 'Not started',
          value: total,
          color: colorScheme.primary,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ProgressCard(
          title: 'In progress',
          value: 0,
          color: colorScheme.secondary,
          faded: true,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ProgressCard(
          title: 'Mastered',
          value: 0,
          color: colorScheme.tertiary,
          faded: true,
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final bool faded;

  const _ProgressCard({
    required this.title,
    required this.value,
    required this.color,
    this.faded = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = faded ? color.withValues(alpha: 0.08) : color.withValues(alpha: 0.12);
    final fg = faded ? color.withValues(alpha: 0.5) : color;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: AppSpacing.iconSmall),
        ],
      ),
    );
  }
}

class _CardList extends StatelessWidget {
  final List<Flashcard> cards;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final void Function(Flashcard card) onEdit;
  final void Function(Flashcard card) onDelete;

  const _CardList({
    required this.cards,
    required this.hasMore,
    required this.onLoadMore,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Cards', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            Row(
              children: [
                Text(
                  'Original order',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {},
                  tooltip: 'Sort',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...cards.map(
          (card) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Card(
              elevation: AppSpacing.elevationLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLarge)),
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TypeChip(type: card.type),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            card.question,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.volume_up_outlined),
                              onPressed: () {},
                              tooltip: 'Play audio',
                            ),
                            IconButton(
                              icon: const Icon(Icons.star_border),
                              onPressed: () {},
                              tooltip: 'Save',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      card.answer,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if ((card.hint ?? '').isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        card.hint ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => onEdit(card),
                          icon: const Icon(Icons.edit, size: AppSpacing.iconSmallMedium),
                          label: const Text('Edit'),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        TextButton.icon(
                          onPressed: () => onDelete(card),
                          icon: Icon(Icons.delete, size: AppSpacing.iconSmallMedium, color: colorScheme.error),
                          label: Text(
                            'Delete',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (hasMore)
          Center(
            child: TextButton.icon(
              onPressed: onLoadMore,
              icon: const Icon(Icons.expand_more),
              label: const Text('Load more'),
            ),
          ),
      ],
    );
  }
}
