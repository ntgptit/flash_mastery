import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// Flash Mastery button widget with various styles
class FMButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final ButtonStyle? buttonStyle;
  final ButtonType type;
  final ButtonSize size;

  const FMButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.buttonStyle,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
  });

  /// Factory for primary button
  factory FMButton.primary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
  }) {
    return FMButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isExpanded: isExpanded,
      icon: icon,
      type: ButtonType.primary,
      size: size,
    );
  }

  /// Factory for secondary button
  factory FMButton.secondary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
  }) {
    return FMButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isExpanded: isExpanded,
      icon: icon,
      type: ButtonType.secondary,
      size: size,
    );
  }

  /// Factory for outlined button
  factory FMButton.outlined({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
  }) {
    return FMButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isExpanded: isExpanded,
      icon: icon,
      type: ButtonType.outlined,
      size: size,
    );
  }

  /// Factory for text button
  factory FMButton.text({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
  }) {
    return FMButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isExpanded: isExpanded,
      icon: icon,
      type: ButtonType.text,
      size: size,
    );
  }

  /// Factory for danger/error button
  factory FMButton.danger({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
  }) {
    return FMButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isExpanded: isExpanded,
      icon: icon,
      type: ButtonType.danger,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = _getPadding();
    final textStyle = _getTextStyle(context);
    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget button;

    switch (type) {
      case ButtonType.primary:
        button = _buildElevatedButton(
          context,
          padding,
          textStyle,
          effectiveOnPressed,
        );
        break;
      case ButtonType.secondary:
        button = _buildFilledTonalButton(
          context,
          padding,
          textStyle,
          effectiveOnPressed,
        );
        break;
      case ButtonType.outlined:
        button = _buildOutlinedButton(
          context,
          padding,
          textStyle,
          effectiveOnPressed,
        );
        break;
      case ButtonType.text:
        button = _buildTextButton(
          context,
          padding,
          textStyle,
          effectiveOnPressed,
        );
        break;
      case ButtonType.danger:
        button = _buildDangerButton(
          context,
          padding,
          textStyle,
          effectiveOnPressed,
        );
        break;
    }

    return isExpanded ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _buildElevatedButton(
    BuildContext context,
    EdgeInsets padding,
    TextStyle? textStyle,
    VoidCallback? effectiveOnPressed,
  ) {
    return ElevatedButton(
      onPressed: effectiveOnPressed,
      style: buttonStyle ??
          ElevatedButton.styleFrom(
            padding: padding,
            textStyle: textStyle,
          ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildFilledTonalButton(
    BuildContext context,
    EdgeInsets padding,
    TextStyle? textStyle,
    VoidCallback? effectiveOnPressed,
  ) {
    return FilledButton.tonal(
      onPressed: effectiveOnPressed,
      style: buttonStyle ??
          FilledButton.styleFrom(
            padding: padding,
            textStyle: textStyle,
          ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildOutlinedButton(
    BuildContext context,
    EdgeInsets padding,
    TextStyle? textStyle,
    VoidCallback? effectiveOnPressed,
  ) {
    return OutlinedButton(
      onPressed: effectiveOnPressed,
      style: buttonStyle ??
          OutlinedButton.styleFrom(
            padding: padding,
            textStyle: textStyle,
          ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
    EdgeInsets padding,
    TextStyle? textStyle,
    VoidCallback? effectiveOnPressed,
  ) {
    return TextButton(
      onPressed: effectiveOnPressed,
      style: buttonStyle ??
          TextButton.styleFrom(
            padding: padding,
            textStyle: textStyle,
          ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildDangerButton(
    BuildContext context,
    EdgeInsets padding,
    TextStyle? textStyle,
    VoidCallback? effectiveOnPressed,
  ) {
    return ElevatedButton(
      onPressed: effectiveOnPressed,
      style: buttonStyle ??
          ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            padding: padding,
            textStyle: textStyle,
          ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: AppSpacing.loaderSizeSmall,
        width: AppSpacing.loaderSizeSmall,
        child: CircularProgressIndicator(
          strokeWidth: AppSpacing.strokeWidthThin,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ButtonType.outlined || type == ButtonType.text
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        );
    }
  }

  TextStyle? _getTextStyle(BuildContext context) {
    switch (size) {
      case ButtonSize.small:
        return Theme.of(context).textTheme.labelSmall;
      case ButtonSize.medium:
        return Theme.of(context).textTheme.labelLarge;
      case ButtonSize.large:
        return Theme.of(context).textTheme.titleMedium;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.iconSmall;
      case ButtonSize.medium:
        return AppSpacing.iconSmallMedium;
      case ButtonSize.large:
        return AppSpacing.iconMedium;
    }
  }
}

/// Button type enum
enum ButtonType {
  primary,
  secondary,
  outlined,
  text,
  danger,
}

/// Button size enum
enum ButtonSize {
  small,
  medium,
  large,
}

/// Icon button with FM styling
class FMIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double size;

  const FMIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size = AppSpacing.iconMedium,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon, size: size),
      onPressed: onPressed,
      color: color,
      style: backgroundColor != null
          ? IconButton.styleFrom(
              backgroundColor: backgroundColor,
            )
          : null,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
