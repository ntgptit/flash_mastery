import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flutter/material.dart';

class FlashcardCardList extends StatelessWidget {
  final List<Flashcard> cards;
  final void Function(Flashcard card) onEdit;
  final void Function(Flashcard card) onDelete;

  const FlashcardCardList({
    super.key,
    required this.cards,
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
              margin: EdgeInsets.zero, // Remove default card margin for consistency
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLarge)),
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            card.question,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14 - 2,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => onEdit(card),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: colorScheme.error),
                          onPressed: () => onDelete(card),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
