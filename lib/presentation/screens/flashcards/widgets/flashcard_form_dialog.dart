import 'package:flutter/material.dart';

import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';

class FlashcardFormDialog extends StatefulWidget {
  final Flashcard? flashcard;
  final Future<void> Function({
    required String question,
    required String answer,
    String? hint,
  }) onSubmit;

  const FlashcardFormDialog({
    super.key,
    this.flashcard,
    required this.onSubmit,
  });

  @override
  State<FlashcardFormDialog> createState() => _FlashcardFormDialogState();
}

class _FlashcardFormDialogState extends State<FlashcardFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;
  late final TextEditingController _answerController;
  late final TextEditingController _hintController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.flashcard?.question ?? '');
    _answerController = TextEditingController(text: widget.flashcard?.answer ?? '');
    _hintController = TextEditingController(text: widget.flashcard?.hint ?? '');
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.flashcard != null;

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
                  isEditing ? 'Edit Flashcard' : 'Create Flashcard',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    hintText: 'Enter question',
                    prefixIcon: Icon(Icons.help_outline),
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                  maxLength: AppConstants.maxQuestionLength,
                  maxLines: AppConstants.defaultMultilineMinLines,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return ErrorMessages.questionRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _answerController,
                  decoration: const InputDecoration(
                    labelText: 'Answer',
                    hintText: 'Enter answer',
                    prefixIcon: Icon(Icons.check_circle_outline),
                    border: OutlineInputBorder(),
                  ),
                  maxLength: AppConstants.maxAnswerLength,
                  maxLines: AppConstants.defaultMultilineMinLines,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return ErrorMessages.answerRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _hintController,
                  decoration: const InputDecoration(
                    labelText: 'Hint (optional)',
                    hintText: 'Enter hint',
                    prefixIcon: Icon(Icons.lightbulb_outline),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: AppConstants.defaultMultilineMinLines,
                  maxLength: AppConstants.maxAnswerLength,
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
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
        hint: _hintController.text.trim().isEmpty ? null : _hintController.text.trim(),
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
