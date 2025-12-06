import 'package:flutter/material.dart';

class DeckSortRow extends StatelessWidget {
  final VoidCallback onTap;
  final String sortLabel;

  const DeckSortRow({super.key, required this.onTap, required this.sortLabel});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(sortLabel, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        IconButton(
          onPressed: onTap,
          icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
