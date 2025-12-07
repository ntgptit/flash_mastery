import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// Common timer display widget for study modes
class StudyTimerDisplay extends StatelessWidget {
  final int timeRemaining;

  const StudyTimerDisplay({
    super.key,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: timeRemaining <= 5
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Text(
        '$timeRemaining s',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: timeRemaining <= 5
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}

