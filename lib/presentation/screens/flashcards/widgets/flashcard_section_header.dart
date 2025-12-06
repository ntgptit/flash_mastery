import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FlashcardSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const FlashcardSectionHeader({super.key, required this.title, required this.subtitle});

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
