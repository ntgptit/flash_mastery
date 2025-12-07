import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// Common card widget for displaying flashcard content (Term/Meaning)
class StudyCard extends StatelessWidget {
  final String label;
  final String content;
  final double? height;
  final TextStyle? contentStyle;

  const StudyCard({
    super.key,
    required this.label,
    required this.content,
    this.height,
    this.contentStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero, // Remove default card margin
      child: Container(
        height: height ?? 200, // Default height
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Center(
                child: Text(
                  content,
                  style: contentStyle ?? Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

