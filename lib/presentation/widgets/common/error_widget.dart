import 'package:flutter/material.dart';

/// A reusable error display widget
class AppErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final Color? iconColor;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.onRetry,
    this.retryButtonText,
    this.iconColor,
  });

  /// Factory for network errors
  factory AppErrorWidget.network({
    String? message,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      title: 'Connection Error',
      message: message ?? 'Please check your internet connection and try again.',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
    );
  }

  /// Factory for server errors
  factory AppErrorWidget.server({
    String? message,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      title: 'Server Error',
      message: message ?? 'Something went wrong on our end. Please try again later.',
      icon: Icons.cloud_off_rounded,
      onRetry: onRetry,
    );
  }

  /// Factory for not found errors
  factory AppErrorWidget.notFound({
    String? message,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      title: 'Not Found',
      message: message ?? 'The resource you are looking for could not be found.',
      icon: Icons.search_off_rounded,
      onRetry: onRetry,
    );
  }

  /// Factory for permission errors
  factory AppErrorWidget.permission({
    String? message,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      title: 'Access Denied',
      message: message ?? 'You do not have permission to access this resource.',
      icon: Icons.lock_outline_rounded,
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = iconColor ?? theme.colorScheme.error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline_rounded,
                size: 64,
                color: errorColor,
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

            // Error Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            // Retry Button
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(retryButtonText ?? 'Try Again'),
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

/// Inline error widget for form fields or small sections
class InlineErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const InlineErrorWidget({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 20,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: onDismiss,
              borderRadius: BorderRadius.circular(16),
              child: Icon(
                Icons.close_rounded,
                size: 20,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
