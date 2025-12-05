import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flutter/material.dart';

class FolderFormDialog extends StatefulWidget {
  final Folder? folder;
  final Folder? parentFolder;
  final List<Folder> allFolders;
  final Function(String name, String? description, String? color, String? parentId) onSubmit;

  const FolderFormDialog({
    super.key,
    this.folder,
    this.parentFolder,
    required this.onSubmit,
    this.allFolders = const [],
  });

  @override
  State<FolderFormDialog> createState() => _FolderFormDialogState();
}

class _FolderFormDialogState extends State<FolderFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  String? _selectedColor;
  String? _selectedParentId;
  late final Map<String, Folder> _folderById;
  late final Set<String> _blockedFolderIds;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.folder?.name ?? '');
    _descriptionController = TextEditingController(text: widget.folder?.description ?? '');
    _selectedColor = widget.folder?.color;
    _selectedParentId = widget.parentFolder?.id ?? widget.folder?.parentId;
    _folderById = {for (final f in widget.allFolders) f.id: f};
    _blockedFolderIds = _computeBlockedIds();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.folder != null;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.dialogMaxWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing ? 'Edit Folder' : 'Create New Folder',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.xl),
                if (widget.allFolders.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: DropdownButtonFormField<String?>(
                      initialValue: _selectedParentId,
                      decoration: const InputDecoration(
                        labelText: 'Parent folder',
                        prefixIcon: Icon(Icons.account_tree_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: _buildParentOptions(),
                      onChanged: (value) {
                        setState(() => _selectedParentId = value);
                      },
                    ),
                  ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Folder Name',
                    hintText: 'Enter folder name',
                    prefixIcon: Icon(Icons.folder),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Please enter a folder name';
                    }
                    if (text.length < AppConstants.minFolderNameLength) {
                      return 'Name must be at least ${AppConstants.minFolderNameLength} characters';
                    }
                    if (text.length > AppConstants.maxFolderNameLength) {
                      return 'Name must not exceed ${AppConstants.maxFolderNameLength} characters';
                    }
                    return null;
                  },
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  maxLines: AppConstants.singleLineMaxLines,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Enter folder description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: AppConstants.defaultMultilineMinLines,
                  maxLength: AppConstants.maxFolderDescriptionLength,
                  validator: (value) {
                    if (value != null &&
                        value.trim().length > AppConstants.maxFolderDescriptionLength) {
                      return 'Description must not exceed ${AppConstants.maxFolderDescriptionLength} characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Choose Color', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: _availableColors.map((color) {
                    final colorString = _colorToString(color);
                    final isSelected = _selectedColor == colorString;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = colorString;
                        });
                      },
                      child: Container(
                        width: AppSpacing.iconExtraLarge,
                        height: AppSpacing.iconExtraLarge,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: AppSpacing.borderWidthThick,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: AppOpacity.medium),
                                    blurRadius: AppSpacing.radiusMedium,
                                    spreadRadius: AppSpacing.borderWidthMedium,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: AppSpacing.iconMedium,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilledButton(
                      onPressed: _handleSubmit,
                      child: Text(isEditing ? 'Update' : 'Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      final color = _selectedColor;

      widget.onSubmit(
        name,
        description.isEmpty ? null : description,
        color,
        _selectedParentId,
      );
    }
  }

  String _colorToString(Color color) {
    final hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${hex.substring(2).toUpperCase()}';
  }

  List<String> _safePath(Folder folder) {
    try {
      return List<String>.from(folder.path);
    } catch (_) {
      return const <String>[];
    }
  }

  List<DropdownMenuItem<String?>> _buildParentOptions() {
    final options = widget.allFolders
        .where((folder) => !_blockedFolderIds.contains(folder.id))
        .toList()
      ..sort((a, b) => _buildPath(a).compareTo(_buildPath(b)));

    return [
      const DropdownMenuItem<String?>(
        value: null,
        child: Text('No parent (root)'),
      ),
      ...options.map(
        (folder) => DropdownMenuItem<String?>(
          value: folder.id,
          child: Text(_buildPath(folder)),
        ),
      ),
    ];
  }

  String _buildPath(Folder folder) {
    final safePath = _safePath(folder);
    if (safePath.isNotEmpty) {
      return safePath.join(' / ');
    }
    final names = <String>[];
    Folder? current = folder;
    int guard = 0;
    while (current != null && guard < 100) {
      names.add(current.name);
      current = current.parentId != null ? _folderById[current.parentId!] : null;
      guard++;
    }
    return names.reversed.join(' / ');
  }

  Set<String> _computeBlockedIds() {
    final blocked = <String>{};
    final currentId = widget.folder?.id;
    if (currentId == null) return blocked;
    blocked.add(currentId);
    final queue = <String>[currentId];
    while (queue.isNotEmpty) {
      final id = queue.removeAt(0);
      for (final child in widget.allFolders.where((f) => f.parentId == id)) {
        if (blocked.add(child.id)) {
          queue.add(child.id);
        }
      }
    }
    return blocked;
  }
}
