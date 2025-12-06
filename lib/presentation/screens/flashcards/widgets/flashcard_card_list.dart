import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';
import 'package:flutter/material.dart';

class FlashcardCardList extends StatelessWidget {
  final List<Flashcard> cards;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final void Function(Flashcard card) onEdit;
  final void Function(Flashcard card) onDelete;

  const FlashcardCardList({
    super.key,
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
