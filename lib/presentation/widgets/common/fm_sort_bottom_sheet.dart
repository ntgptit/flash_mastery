import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// A reusable bottom sheet widget for sorting items.
///
/// Features:
/// - Displays a list of sort options
/// - Shows a check mark next to the currently selected option
/// - Automatically closes after selection
/// - Fully customizable title and options
///
/// Example usage:
/// ```dart
/// FmSortBottomSheet.show(
///   context: context,
///   title: 'Sort decks',
///   currentValue: _sort,
///   options: [
///     SortOption(value: 'latest', label: 'Latest'),
///     SortOption(value: 'name,asc', label: 'Name (A-Z)'),
///   ],
///   onSelected: (value) {
///     setState(() => _sort = value);
///     // Load data with new sort
///   },
/// );
/// ```
class FmSortBottomSheet extends StatelessWidget {
  /// Title displayed at the top of the bottom sheet
  final String title;

  /// List of available sort options
  final List<SortOption> options;

  /// Currently selected sort value
  final String currentValue;

  /// Callback when a sort option is selected
  final ValueChanged<String> onSelected;

  const FmSortBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.currentValue,
    required this.onSelected,
  });

  /// Static method to show the sort bottom sheet
  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<SortOption> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => FmSortBottomSheet(
        title: title,
        options: options,
        currentValue: currentValue,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          ...options.map(
            (option) => ListTile(
              title: Text(option.label),
              trailing: currentValue == option.value
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                onSelected(option.value);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

/// Represents a single sort option
class SortOption {
  /// The value to be used when this option is selected
  final String value;

  /// The display label for this option
  final String label;

  const SortOption({
    required this.value,
    required this.label,
  });
}
