import 'package:flutter/material.dart';

/// Custom dialog widget
class FMDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final String? contentText;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;
  final MainAxisAlignment actionsAlignment;

  const FMDialog({
    super.key,
    this.title,
    this.content,
    this.contentText,
    this.actions,
    this.icon,
    this.iconColor,
    this.actionsAlignment = MainAxisAlignment.end,
  });

  /// Show custom dialog
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? content,
    String? contentText,
    List<Widget>? actions,
    IconData? icon,
    Color? iconColor,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => FMDialog(
        title: title,
        content: content,
        contentText: contentText,
        actions: actions,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  /// Show confirmation dialog
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return show<bool>(
      context: context,
      title: title,
      contentText: message,
      icon: isDestructive ? Icons.warning_rounded : Icons.help_outline_rounded,
      iconColor: isDestructive
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: isDestructive
              ? ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Show success dialog
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return show(
      context: context,
      title: title,
      contentText: message,
      icon: Icons.check_circle_rounded,
      iconColor: Colors.green,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// Show error dialog
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return show(
      context: context,
      title: title,
      contentText: message,
      icon: Icons.error_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// Show info dialog
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return show(
      context: context,
      title: title,
      contentText: message,
      icon: Icons.info_rounded,
      iconColor: Theme.of(context).colorScheme.primary,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    (iconColor ?? theme.colorScheme.primary).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: iconColor ?? theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      content: content ??
          (contentText != null
              ? Text(
                  contentText!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                )
              : null),
      actions: actions,
      actionsAlignment: actionsAlignment,
    );
  }
}

/// Loading dialog
class LoadingDialog extends StatelessWidget {
  final String? message;

  const LoadingDialog({
    super.key,
    this.message,
  });

  /// Show loading dialog
  static void show({
    required BuildContext context,
    String? message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  /// Hide loading dialog
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Input dialog for text input
class InputDialog extends StatefulWidget {
  final String title;
  final String? hint;
  final String? initialValue;
  final String? confirmText;
  final String? cancelText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;

  const InputDialog({
    super.key,
    required this.title,
    this.hint,
    this.initialValue,
    this.confirmText,
    this.cancelText,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  /// Show input dialog
  static Future<String?> show({
    required BuildContext context,
    required String title,
    String? hint,
    String? initialValue,
    String? confirmText,
    String? cancelText,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => InputDialog(
        title: title,
        hint: hint,
        initialValue: initialValue,
        confirmText: confirmText,
        cancelText: cancelText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: widget.validator,
          onFieldSubmitted: (_) => _handleConfirm(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelText ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleConfirm,
          child: Text(widget.confirmText ?? 'Confirm'),
        ),
      ],
    );
  }
}

/// Full screen dialog
class FullScreenDialog extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;

  const FullScreenDialog({
    super.key,
    this.title,
    required this.body,
    this.actions,
  });

  /// Show full screen dialog
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget body,
    List<Widget>? actions,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullScreenDialog(
          title: title,
          body: body,
          actions: actions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title != null ? Text(title!) : null,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: actions,
      ),
      body: body,
    );
  }
}
