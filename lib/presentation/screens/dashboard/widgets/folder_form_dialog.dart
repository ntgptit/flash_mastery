import 'package:flutter/material.dart';
import '../../../../domain/entities/folder.dart';

class FolderFormDialog extends StatefulWidget {
  final Folder? folder;
  final Function(String name, String? description, String? color) onSubmit;

  const FolderFormDialog({
    super.key,
    this.folder,
    required this.onSubmit,
  });

  @override
  State<FolderFormDialog> createState() => _FolderFormDialogState();
}

class _FolderFormDialogState extends State<FolderFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  String? _selectedColor;

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
    _descriptionController =
        TextEditingController(text: widget.folder?.description ?? '');
    _selectedColor = widget.folder?.color;
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
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Folder Name',
                    hintText: 'Enter folder name',
                    prefixIcon: Icon(Icons.folder),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a folder name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    if (value.trim().length > 50) {
                      return 'Name must not exceed 50 characters';
                    }
                    return null;
                  },
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Enter folder description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  maxLength: 200,
                  validator: (value) {
                    if (value != null && value.trim().length > 200) {
                      return 'Description must not exceed 200 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Choose Color',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withAlpha(100),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
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
      );
    }
  }

  String _colorToString(Color color) {
    final hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${hex.substring(2).toUpperCase()}';
  }
}
