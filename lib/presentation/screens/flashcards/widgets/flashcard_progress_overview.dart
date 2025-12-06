import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FlashcardProgressOverview extends StatelessWidget {
  final int total;

  const FlashcardProgressOverview({super.key, required this.total});

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
