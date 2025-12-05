import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flutter/material.dart';

/// Breadcrumb navigation for nested folders.
class FolderBreadcrumb extends StatelessWidget {
  final List<Folder> allFolders;
  final Folder current;
  final VoidCallback? onRootTap;
  final void Function(Folder folder) onFolderTap;

  const FolderBreadcrumb({
    super.key,
    required this.allFolders,
    required this.current,
    this.onRootTap,
    required this.onFolderTap,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    // Scroll to end after build to ensure deepest folder is visible.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });

    final path = _buildPath();
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _BreadcrumbChip(
            label: 'Folders',
            icon: Icons.folder_open_outlined,
            onTap: onRootTap,
            color: colorScheme.primary,
            isActive: false,
          ),
          for (final folder in path) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Icon(Icons.chevron_right, size: AppSpacing.iconSmall, color: colorScheme.onSurfaceVariant),
            ),
            _BreadcrumbChip(
              label: folder.name,
              icon: Icons.folder,
              onTap: () => onFolderTap(folder),
              color: colorScheme.secondary,
              isActive: folder.id == current.id,
            ),
          ],
        ],
      ),
    );
  }

  List<Folder> _buildPath() {
    final map = {for (final f in allFolders) f.id: f};
    Folder? node = current;
    final path = <Folder>[];
    while (node != null) {
      path.insert(0, node);
      final parentId = node.parentId;
      node = parentId != null ? map[parentId] : null;
    }
    return path;
  }
}

class _BreadcrumbChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final bool isActive;

  const _BreadcrumbChip({
    required this.label,
    required this.icon,
    this.onTap,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color.withValues(alpha: AppOpacity.mediumLow);
    final effectiveColor = isActive ? color.withValues(alpha: 0.7) : baseColor;
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
        );
    final chip = Container(
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: isActive
            ? Border.all(color: Colors.white.withValues(alpha: AppOpacity.low), width: 1)
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.iconSmall, color: Colors.white),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: textStyle,
          ),
        ],
      ),
    );

    if (onTap == null) return chip;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      child: chip,
    );
  }
}
