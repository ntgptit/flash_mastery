import 'package:flutter/material.dart';

import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:flash_mastery/domain/entities/folder.dart';

class DeckFormDialog extends StatefulWidget {
  final Deck? deck;
  final List<Folder> folders;
  final String? initialFolderId;
  final Future<void> Function(String name, String? description, String? folderId) onSubmit;

  const DeckFormDialog({
    super.key,
    this.deck,
    required this.folders,
    this.initialFolderId,
    required this.onSubmit,
  });

  @override
  State<DeckFormDialog> createState() => _DeckFormDialogState();
}

class _DeckFormDialogState extends State<DeckFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  String? _selectedFolderId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.deck?.name ?? '');
    _descriptionController = TextEditingController(text: widget.deck?.description ?? '');
    _selectedFolderId = widget.deck?.folderId ?? widget.initialFolderId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.deck != null;
    _selectedFolderId ??= widget.folders.isNotEmpty ? widget.folders.first.id : null;
    if (_selectedFolderId != null &&
        widget.folders.every((folder) => folder.id != _selectedFolderId)) {
      _selectedFolderId = widget.folders.isNotEmpty ? widget.folders.first.id : null;
    }

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
                  isEditing ? 'Edit Deck' : 'Create Deck',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Deck Name',
                    hintText: 'Enter deck name',
                    prefixIcon: Icon(Icons.layers_outlined),
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                  maxLength: AppConstants.maxDeckNameLength,
                  maxLines: AppConstants.singleLineMaxLines,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Please enter a deck name';
                    }
                    if (text.length < AppConstants.minDeckNameLength) {
                      return 'Name must be at least ${AppConstants.minDeckNameLength} characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Enter deck description',
                    prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: AppConstants.defaultMultilineMinLines,
                  maxLength: AppConstants.maxDeckDescriptionLength,
                ),
                const SizedBox(height: AppSpacing.lg),
                DropdownButtonFormField<String>(
                  initialValue: _selectedFolderId,
                  decoration: const InputDecoration(
                    labelText: 'Folder',
                    prefixIcon: Icon(Icons.folder_open_rounded),
                    border: OutlineInputBorder(),
                  ),
                  items: widget.folders
                      .map(
                        (folder) => DropdownMenuItem(
                          value: folder.id,
                          child: Text(
                            folder.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFolderId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a folder';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _handleSubmit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: AppSpacing.loaderSizeSmall,
                              height: AppSpacing.loaderSizeSmall,
                              child: CircularProgressIndicator(
                                strokeWidth: AppSpacing.strokeWidthThin,
                              ),
                            )
                          : Text(isEditing ? 'Update' : 'Create'),
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

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(
        _nameController.text.trim(),
        _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        _selectedFolderId,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
