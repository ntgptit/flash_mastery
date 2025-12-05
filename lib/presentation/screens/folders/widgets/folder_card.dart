import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flutter/material.dart';

class FolderCard extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color? colorOverride;
  final VoidCallback? onAddSubfolder;

  const FolderCard({
    super.key,
    required this.folder,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.colorOverride,
    this.onAddSubfolder,
  });

  @override
  Widget build(BuildContext context) {
    final fallbackColor = Theme.of(context).colorScheme.primary;
    final color = colorOverride ?? _parseColor(folder.color, fallbackColor);

    return Card(
      elevation: AppSpacing.elevationLow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: AppOpacity.veryHigh),
                    color.withValues(alpha: AppOpacity.mediumLow),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.folder, color: Colors.white, size: AppSpacing.iconSmallMedium),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'edit') {
                            onEdit();
                          } else if (value == 'delete') {
                            onDelete();
                          } else if (value == 'subfolder') {
                            onAddSubfolder?.call();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'subfolder',
                            child: Row(
                              children: [
                                Icon(Icons.create_new_folder, size: AppSpacing.iconSmall),
                                SizedBox(width: AppSpacing.xs),
                                Text('Add subfolder'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: AppSpacing.iconSmall),
                                SizedBox(width: AppSpacing.xs),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: AppSpacing.iconSmall,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    folder.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((folder.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      folder.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: AppOpacity.veryHigh),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _BadgeChip(
                        label: '${folder.deckCount} deck${folder.deckCount != 1 ? 's' : ''}',
                        color: Colors.white.withValues(alpha: AppOpacity.low),
                        textColor: Colors.white,
                      ),
                      _BadgeChip(
                        label:
                            '${folder.subFolderCount} subfolder${folder.subFolderCount == 1 ? '' : 's'}',
                        color: Colors.white.withValues(alpha: AppOpacity.low),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String? colorString, Color fallback) {
    if (colorString == null || colorString.isEmpty) {
      return fallback;
    }

    try {
      final hexColor = colorString.replaceAll('#', '');
      if (hexColor.length == 6) {
        return Color(int.parse('FF$hexColor', radix: 16));
      } else if (hexColor.length == 8) {
        return Color(int.parse(hexColor, radix: 16));
      }
    } catch (_) {
      return fallback;
    }

    return fallback;
  }
}

class FolderTile extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isGrid;
  final Color? fixedColor;
  final VoidCallback? onAddSubfolder;

  const FolderTile({
    super.key,
    required this.folder,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.isGrid,
    this.fixedColor,
    this.onAddSubfolder,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return FolderCard(
        folder: folder,
        onTap: onTap,
        onEdit: onEdit,
        onDelete: onDelete,
        colorOverride: fixedColor,
        onAddSubfolder: onAddSubfolder,
      );
    }

    return Card(
      elevation: AppSpacing.elevationLow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          folder.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          (folder.description?.isNotEmpty ?? false) ? folder.description! : 'No description',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                      if (value == 'subfolder') onAddSubfolder?.call();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'subfolder',
                        child: ListTile(
                          leading: Icon(Icons.create_new_folder),
                          title: Text('Add subfolder'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          title: Text(
                            'Delete',
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: AppSpacing.iconSmallMedium,
                        color: fixedColor ?? Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${folder.deckCount} deck${folder.deckCount == 1 ? '' : 's'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        Icons.create_new_folder_outlined,
                        size: AppSpacing.iconSmallMedium,
                        color: fixedColor ?? Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${folder.subFolderCount} subfolder${folder.subFolderCount == 1 ? '' : 's'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _BadgeChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
