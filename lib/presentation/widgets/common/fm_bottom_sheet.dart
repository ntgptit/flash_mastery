import 'package:flutter/material.dart';

/// Custom bottom sheet widget
class FMBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool isDismissible;
  final bool enableDrag;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const FMBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.isDismissible = true,
    this.enableDrag = true,
    this.height,
    this.padding,
  });

  /// Show modal bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => FMBottomSheet(
        title: title,
        height: height,
        padding: padding,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          if (enableDrag)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          // Title
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (isDismissible)
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Content
          Flexible(child: child),
        ],
      ),
    );
  }
}

/// List bottom sheet for selection
class ListBottomSheet<T> extends StatelessWidget {
  final String? title;
  final List<T> items;
  final String Function(T) itemBuilder;
  final IconData? Function(T)? iconBuilder;
  final void Function(T) onItemSelected;

  const ListBottomSheet({
    super.key,
    this.title,
    required this.items,
    required this.itemBuilder,
    this.iconBuilder,
    required this.onItemSelected,
  });

  /// Show list bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required List<T> items,
    required String Function(T) itemBuilder,
    IconData? Function(T)? iconBuilder,
  }) {
    return FMBottomSheet.show<T>(
      context: context,
      title: title,
      child: ListBottomSheet<T>(
        items: items,
        itemBuilder: itemBuilder,
        iconBuilder: iconBuilder,
        onItemSelected: (item) => Navigator.of(context).pop(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        final icon = iconBuilder?.call(item);

        return ListTile(
          leading: icon != null ? Icon(icon) : null,
          title: Text(itemBuilder(item)),
          onTap: () => onItemSelected(item),
        );
      },
    );
  }
}

/// Action bottom sheet with list of actions
class ActionBottomSheet extends StatelessWidget {
  final String? title;
  final List<BottomSheetAction> actions;

  const ActionBottomSheet({
    super.key,
    this.title,
    required this.actions,
  });

  /// Show action bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required List<BottomSheetAction> actions,
  }) {
    return FMBottomSheet.show<T>(
      context: context,
      title: title,
      child: ActionBottomSheet(
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: actions.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final action = actions[index];

        return ListTile(
          leading: action.icon != null
              ? Icon(
                  action.icon,
                  color: action.isDestructive
                      ? Theme.of(context).colorScheme.error
                      : null,
                )
              : null,
          title: Text(
            action.title,
            style: TextStyle(
              color: action.isDestructive
                  ? Theme.of(context).colorScheme.error
                  : null,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
            action.onTap();
          },
        );
      },
    );
  }
}

/// Bottom sheet action model
class BottomSheetAction {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const BottomSheetAction({
    required this.title,
    this.icon,
    required this.onTap,
    this.isDestructive = false,
  });
}

/// Draggable scrollable bottom sheet
class DraggableBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  const DraggableBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.95,
  });

  /// Show draggable bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 0.95,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableBottomSheet(
        title: title,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
