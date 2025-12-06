import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FlashcardActionList extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onStudy;
  final VoidCallback onTest;
  final VoidCallback onMatch;
  final VoidCallback onBlast;

  const FlashcardActionList({
    super.key,
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
