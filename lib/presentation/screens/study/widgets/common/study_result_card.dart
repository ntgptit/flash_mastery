import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// Common card widget for displaying study results (correct/incorrect)
class StudyResultCard extends StatelessWidget {
  final bool isCorrect;
  final String message;
  final IconData icon;

  const StudyResultCard({
    super.key,
    required this.isCorrect,
    required this.message,
    this.icon = Icons.info,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCorrect
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.errorContainer,
      margin: EdgeInsets.zero, // Match other cards
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : icon,
              color: isCorrect
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isCorrect
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onErrorContainer,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

