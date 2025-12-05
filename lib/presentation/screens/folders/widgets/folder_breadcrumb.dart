import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flutter/material.dart';

/// Breadcrumb navigation for nested folders.
class FolderBreadcrumb extends StatelessWidget {
  final List<Folder> allFolders;
  final Folder current;
  final VoidCallback onRootTap;
  final void Function(Folder folder) onFolderTap;

  const FolderBreadcrumb({
    super.key,
    required this.allFolders,
    required this.current,
    required this.onRootTap,
    required this.onFolderTap,
  });

  @override
  Widget build(BuildContext context) {
    final path = _buildPath();
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        _BreadcrumbChip(
          label: 'Folders',
          icon: Icons.folder_open_outlined,
          onTap: onRootTap,
          color: colorScheme.primary,
        ),
        for (final folder in path) ...[
          Icon(Icons.chevron_right, size: AppSpacing.iconSmall, color: colorScheme.onSurfaceVariant),
          _BreadcrumbChip(
            label: folder.name,
            icon: Icons.folder,
            onTap: () => onFolderTap(folder),
            color: colorScheme.secondary,
          ),
        ],
      ],
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
  final VoidCallback onTap;
  final Color color;

  const _BreadcrumbChip({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: AppSpacing.iconSmall, color: Colors.white),
      backgroundColor: color.withValues(alpha: AppOpacity.mediumLow),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      label: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
      ),
      onPressed: onTap,
    );
  }
}
