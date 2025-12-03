import 'package:flutter/material.dart';

/// A reusable empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final Widget? illustration;
  final VoidCallback? onAction;
  final String? actionButtonText;
  final IconData? actionIcon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.illustration,
    this.onAction,
    this.actionButtonText,
    this.actionIcon,
  });

  /// Factory for empty list
  factory EmptyStateWidget.list({
    String? message,
    VoidCallback? onAction,
    String? actionButtonText,
  }) {
    return EmptyStateWidget(
      title: 'No Items Found',
      message: message ?? 'There are no items to display at the moment.',
      icon: Icons.inbox_rounded,
      onAction: onAction,
      actionButtonText: actionButtonText,
    );
  }

  /// Factory for empty search results
  factory EmptyStateWidget.search({
    String? searchQuery,
    VoidCallback? onAction,
  }) {
    return EmptyStateWidget(
      title: 'No Results Found',
      message: searchQuery != null
          ? 'No results found for "$searchQuery"'
          : 'Try adjusting your search criteria.',
      icon: Icons.search_off_rounded,
      onAction: onAction,
      actionButtonText: 'Clear Search',
    );
  }

  /// Factory for empty favorites
  factory EmptyStateWidget.favorites({
    VoidCallback? onAction,
  }) {
    return EmptyStateWidget(
      title: 'No Favorites Yet',
      message: 'Start adding items to your favorites to see them here.',
      icon: Icons.favorite_border_rounded,
      onAction: onAction,
      actionButtonText: 'Browse Items',
    );
  }

  /// Factory for no notifications
  factory EmptyStateWidget.notifications() {
    return const EmptyStateWidget(
      title: 'No Notifications',
      message: "You're all caught up! No new notifications.",
      icon: Icons.notifications_none_rounded,
    );
  }

  /// Factory for no connection
  factory EmptyStateWidget.noConnection({
    VoidCallback? onRetry,
  }) {
    return EmptyStateWidget(
      title: 'No Connection',
      message: 'Unable to load data. Please check your internet connection.',
      icon: Icons.wifi_off_rounded,
      onAction: onRetry,
      actionButtonText: 'Retry',
      actionIcon: Icons.refresh_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration or Icon
            if (illustration != null)
              illustration!
            else if (icon != null)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 72,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            const SizedBox(height: 24),

            // Title
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),

            // Action Button
            if (onAction != null && actionButtonText != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(actionIcon ?? Icons.add_rounded),
                label: Text(actionButtonText!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget with custom image
class EmptyStateWithImage extends StatelessWidget {
  final String imagePath;
  final String message;
  final String? title;
  final VoidCallback? onAction;
  final String? actionButtonText;

  const EmptyStateWithImage({
    super.key,
    required this.imagePath,
    required this.message,
    this.title,
    this.onAction,
    this.actionButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: title,
      message: message,
      illustration: Image.asset(
        imagePath,
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      ),
      onAction: onAction,
      actionButtonText: actionButtonText,
    );
  }
}
