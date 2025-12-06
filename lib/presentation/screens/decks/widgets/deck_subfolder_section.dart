import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_card.dart';
import 'package:flutter/material.dart';

class DeckSubfolderSection extends StatelessWidget {
  final List<Folder> subfolders;
  final VoidCallback onCreate;
  final void Function(Folder folder) onOpen;
  final void Function(Folder folder) onEdit;
  final void Function(Folder folder) onDelete;
  final void Function(Folder folder)? onAddSubfolder;

  const DeckSubfolderSection({
    super.key,
    required this.subfolders,
    required this.onCreate,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    this.onAddSubfolder,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subfolders', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            TextButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.create_new_folder_outlined),
              label: const Text('New subfolder'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (subfolders.isEmpty)
          Card(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.folder_open_outlined, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'No subfolders yet. Create one to organize deeper.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: subfolders
                .map(
                  (folder) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: FolderTile(
                      folder: folder,
                      onTap: () => onOpen(folder),
                      onEdit: () => onEdit(folder),
                      onAddSubfolder:
                          onAddSubfolder != null ? () => onAddSubfolder!(folder) : null,
                      onDelete: () => onDelete(folder),
                      isGrid: false,
                      fixedColor: colorScheme.primary,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
