import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// Common progress indicator widget for study modes
class StudyProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final int? queueCount;

  const StudyProgressIndicator({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    this.queueCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: (currentIndex + 1) / totalCount,
          minHeight: 4,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${currentIndex + 1} / $totalCount',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (queueCount != null && queueCount! > 0)
              Text(
                'To Review: $queueCount',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
          ],
        ),
      ],
    );
  }
}

