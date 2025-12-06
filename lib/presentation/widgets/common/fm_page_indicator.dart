import 'package:flutter/material.dart';

/// A customizable page indicator widget that shows dots representing pages.
///
/// Features:
/// - Shows all dots when total count is <= maxVisibleDots (default: 7)
/// - Shows a sliding window of dots when total count > maxVisibleDots
/// - Animated transitions between states
/// - Current page is always centered (when possible)
/// - Faded dots at edges indicate more pages available
class FmPageIndicator extends StatelessWidget {
  /// Total number of pages
  final int itemCount;

  /// Current active page index (0-based)
  final int currentIndex;

  /// Maximum number of dots to show at once
  final int maxVisibleDots;

  /// Size of active dot
  final double activeDotSize;

  /// Size of inactive dot
  final double inactiveDotSize;

  /// Color of active dot
  final Color? activeColor;

  /// Color of inactive dots
  final Color? inactiveColor;

  /// Color of edge indicator dots (when there are more pages)
  final Color? edgeIndicatorColor;

  /// Horizontal spacing between dots
  final double spacing;

  const FmPageIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.maxVisibleDots = 7,
    this.activeDotSize = 10,
    this.inactiveDotSize = 6,
    this.activeColor,
    this.inactiveColor,
    this.edgeIndicatorColor,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final effectiveActiveColor = activeColor ?? colorScheme.primary;
    final effectiveInactiveColor =
        inactiveColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
    final effectiveEdgeColor =
        edgeIndicatorColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.2);

    // If we have fewer dots than max, show all
    if (itemCount <= maxVisibleDots) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (i) {
          final isActive = i == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: spacing),
            width: isActive ? activeDotSize : inactiveDotSize,
            height: inactiveDotSize,
            decoration: BoxDecoration(
              color: isActive ? effectiveActiveColor : effectiveInactiveColor,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }),
      );
    }

    // For many dots, show a subset with current page in center
    final List<int> visibleIndices = [];
    final halfVisible = maxVisibleDots ~/ 2;

    int start = currentIndex - halfVisible;
    int end = currentIndex + halfVisible;

    // Adjust if we're near the start
    if (start < 0) {
      end += start.abs();
      start = 0;
    }

    // Adjust if we're near the end
    if (end >= itemCount) {
      start -= (end - itemCount + 1);
      end = itemCount - 1;
      if (start < 0) start = 0;
    }

    for (int i = start; i <= end; i++) {
      visibleIndices.add(i);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Leading edge indicator
        if (start > 0) ...[
          Container(
            margin: EdgeInsets.symmetric(horizontal: spacing),
            width: inactiveDotSize,
            height: inactiveDotSize,
            decoration: BoxDecoration(
              color: effectiveEdgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          SizedBox(width: spacing / 2),
        ],

        // Main visible dots
        ...visibleIndices.map((i) {
          final isActive = i == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: spacing),
            width: isActive ? activeDotSize : inactiveDotSize,
            height: inactiveDotSize,
            decoration: BoxDecoration(
              color: isActive ? effectiveActiveColor : effectiveInactiveColor,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }),

        // Trailing edge indicator
        if (end < itemCount - 1) ...[
          SizedBox(width: spacing / 2),
          Container(
            margin: EdgeInsets.symmetric(horizontal: spacing),
            width: inactiveDotSize,
            height: inactiveDotSize,
            decoration: BoxDecoration(
              color: effectiveEdgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ],
    );
  }
}
