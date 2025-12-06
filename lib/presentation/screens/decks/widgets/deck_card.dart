import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flutter/material.dart';

class DeckCard extends StatelessWidget {
  final Deck deck;
  final Folder folder;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DeckCard({
    super.key,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          deck.name,
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _TypeChip(type: deck.type),
                    ],
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

class _TypeChip extends StatelessWidget {
  final FlashcardType type;

  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isVocab = type == FlashcardType.vocabulary;
    final bg = isVocab
        ? colorScheme.primary.withValues(alpha: AppOpacity.low)
        : colorScheme.secondary.withValues(alpha: AppOpacity.low);
    final fg = isVocab ? colorScheme.primary : colorScheme.secondary;
    return Container(
      margin: const EdgeInsets.only(left: AppSpacing.sm),
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
