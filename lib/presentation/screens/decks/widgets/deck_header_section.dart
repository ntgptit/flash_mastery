import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

class DeckHeaderSection extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final void Function(String value) onMenuSelect;

  const DeckHeaderSection({
    super.key,
    required this.title,
    required this.description,
    required this.onBack,
    required this.onSearch,
    required this.onMenuSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back), tooltip: 'Back'),
            const Spacer(),
            IconButton(onPressed: onSearch, icon: const Icon(Icons.search), tooltip: 'Search'),
            PopupMenuButton<String>(
              onSelected: onMenuSelect,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'refresh', child: Text('Refresh')),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: AppOpacity.low),
              borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
            ),
            child: Icon(Icons.folder, color: colorScheme.onPrimary, size: AppSpacing.iconLarge),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: Text(title, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Text(
            description,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
