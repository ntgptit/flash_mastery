import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// Custom AppBar widget with various styles
class FMAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  const FMAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = AppSpacing.elevationNone,
    this.centerTitle = true,
    this.bottom,
  });

  /// Factory for simple app bar with title
  factory FMAppBar.simple({
    required String title,
    List<Widget>? actions,
    bool centerTitle = true,
  }) {
    return FMAppBar(
      title: title,
      actions: actions,
      centerTitle: centerTitle,
    );
  }

  /// Factory for search app bar
  factory FMAppBar.search({
    required TextEditingController controller,
    required void Function(String) onChanged,
    String? hintText,
    VoidCallback? onClear,
    VoidCallback? onBack,
  }) {
    return FMAppBar(
      titleWidget: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: hintText ?? 'Search...',
          border: InputBorder.none,
          hintStyle: AppTypography.bodyLarge,
        ),
        style: AppTypography.bodyLarge,
        onChanged: onChanged,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: onBack,
      ),
      actions: [
        if (onClear != null)
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: onClear,
          ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  /// Factory for transparent app bar (for use with images/gradients)
  factory FMAppBar.transparent({
    String? title,
    List<Widget>? actions,
    VoidCallback? onBack,
  }) {
    return FMAppBar(
      title: title,
      actions: actions,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBack,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? AppSpacing.elevationNone),
      );
}

/// SliverAppBar with custom styling
class FMSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double expandedHeight;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;
  final bool snap;

  const FMSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.expandedHeight = AppSpacing.sliverExpandedHeight,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
  });

  /// Factory for image header
  factory FMSliverAppBar.withImage({
    required String imageUrl,
    String? title,
    List<Widget>? actions,
    double expandedHeight = AppSpacing.sliverExpandedHeightLarge,
  }) {
    return FMSliverAppBar(
      title: title,
      actions: actions,
      expandedHeight: expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      pinned: pinned,
      floating: floating,
      snap: snap,
    );
  }
}

/// Bottom app bar with floating action button
class FMBottomAppBar extends StatelessWidget {
  final List<Widget> children;
  final FloatingActionButton? floatingActionButton;
  final Color? backgroundColor;
  final double height;
  final FloatingActionButtonLocation? fabLocation;

  const FMBottomAppBar({
    super.key,
    required this.children,
    this.floatingActionButton,
    this.backgroundColor,
    this.height = AppSpacing.bottomAppBarHeight,
    this.fabLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SizedBox.shrink(),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation:
          fabLocation ?? FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: backgroundColor,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children,
        ),
      ),
    );
  }
}

/// Tab bar widget
class FMTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final bool isScrollable;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const FMTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      tabs: tabs,
      isScrollable: isScrollable,
      indicatorColor: indicatorColor,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
