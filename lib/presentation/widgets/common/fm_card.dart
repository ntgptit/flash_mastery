import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// Custom card widget with various styles
class FMCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final double borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Border? border;

  const FMCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius = AppSpacing.radiusLarge,
    this.onTap,
    this.onLongPress,
    this.border,
  });

  /// Factory for elevated card
  factory FMCard.elevated({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = AppSpacing.elevationLow,
    double borderRadius = AppSpacing.radiusLarge,
    VoidCallback? onTap,
  }) {
    return FMCard(
      padding: padding,
      margin: margin,
      elevation: elevation,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for outlined card
  factory FMCard.outlined({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = AppSpacing.radiusLarge,
    Color? borderColor,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    return FMCard(
      padding: padding,
      margin: margin,
      elevation: AppSpacing.elevationNone,
      borderRadius: borderRadius,
      onTap: onTap,
      border: Border.all(
        color: borderColor ?? Theme.of(context).colorScheme.outline,
      ),
      child: child,
    );
  }

  /// Factory for filled card
  factory FMCard.filled({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double borderRadius = AppSpacing.radiusLarge,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    return FMCard(
      padding: padding,
      margin: margin,
      elevation: AppSpacing.elevationNone,
      borderRadius: borderRadius,
      color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
      onTap: onTap,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation,
      color: color,
      margin: margin ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: border != null
            ? border!.top
            : BorderSide.none,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );

    if (onTap != null || onLongPress != null) {
      return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    return card;
  }
}

/// Info card with icon and title
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FMCard(
      onTap: onTap,
      color: backgroundColor,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: (iconColor ?? theme.colorScheme.primary)
                  .withValues(alpha: AppOpacity.extraLow),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            ),
            child: Icon(
              icon,
              color: iconColor ?? theme.colorScheme.primary,
              size: AppSpacing.iconMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: AppOpacity.high),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: AppSpacing.iconSmall,
              color:
                  theme.colorScheme.onSurface.withValues(alpha: AppOpacity.medium),
            ),
        ],
      ),
    );
  }
}

/// Stat card for displaying statistics
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
  final String? trend;
  final bool isTrendPositive;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.trend,
    this.isTrendPositive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.colorScheme.primary;

    return FMCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: AppOpacity.extraLow),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                  child: Icon(
                    icon,
                    color: cardColor,
                    size: AppSpacing.iconSmallMedium,
                  ),
                ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: (isTrendPositive ? AppColors.success : AppColors.error)
                        .withValues(alpha: AppOpacity.extraLow),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isTrendPositive
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: AppSpacing.iconExtraSmall,
                        color: isTrendPositive ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        trend!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isTrendPositive ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cardColor,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: AppOpacity.high),
            ),
          ),
        ],
      ),
    );
  }
}

/// Feature card with image
class FeatureCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? imageUrl;
  final Widget? image;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? action;

  const FeatureCard({
    super.key,
    required this.title,
    this.description,
    this.imageUrl,
    this.image,
    this.icon,
    this.onTap,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FMCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image or Icon
          if (image != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusLarge),
              ),
              child: image!,
            )
          else if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusLarge),
              ),
              child: Image.network(
                imageUrl!,
                height: AppSpacing.featureMediaHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else if (icon != null)
            Container(
              height: AppSpacing.featureMediaHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLarge),
                ),
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconHuge,
                color: theme.colorScheme.primary,
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: AppOpacity.high),
                    ),
                  ),
                ],
                if (action != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
