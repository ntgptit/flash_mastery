import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/factories/study_mode_factory.dart';
import 'package:flutter/material.dart';

class GuessModeWidget extends StatefulWidget {
  final StudySession session;
  final List<Flashcard> flashcards;
  final List<Flashcard> allFlashcards;
  final VoidCallback onComplete;

  const GuessModeWidget({
    super.key,
    required this.session,
    required this.flashcards,
    required this.allFlashcards,
    required this.onComplete,
  });

  @override
  State<GuessModeWidget> createState() => _GuessModeWidgetState();
}

class _GuessModeWidgetState extends State<GuessModeWidget> {
  int _currentIndex = 0;
  String? _selectedAnswer;
  final Map<int, bool> _results = {}; // index -> isCorrect

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return const Center(child: Text('No flashcards in this batch'));
    }

    final currentCard = widget.flashcards[_currentIndex];
    final handler = StudyModeFactory.createHandler(widget.session.currentMode);
    final options = handler.getOptions(
      flashcard: currentCard,
      allFlashcards: widget.allFlashcards,
    ) ?? [];

    final isComplete = _currentIndex >= widget.flashcards.length - 1 && _results.containsKey(_currentIndex);
    final isAnswered = _results.containsKey(_currentIndex);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.flashcards.length,
            minHeight: 4,
          ),
          const SizedBox(height: AppSpacing.lg),

          Text(
            '${_currentIndex + 1} / ${widget.flashcards.length}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Meaning displayed
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  Text(
                    'Meaning',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    currentCard.answer,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Multiple choice options
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = _selectedAnswer == option;
                final isCorrect = option == currentCard.question;
                final showResult = isAnswered && isSelected;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: InkWell(
                    onTap: isAnswered
                        ? null
                        : () {
                            setState(() {
                              _selectedAnswer = option;
                              final isCorrectAnswer = handler.validateAnswer(
                                flashcard: currentCard,
                                userAnswer: option,
                              );
                              _results[_currentIndex] = isCorrectAnswer;
                            });
                          },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: showResult
                            ? (isCorrect
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.errorContainer)
                            : isSelected
                                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                                : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          if (showResult)
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.error,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Navigation buttons
          Row(
            children: [
              if (_currentIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentIndex--;
                        _selectedAnswer = null;
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                ),
              if (_currentIndex > 0) const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton.icon(
                  onPressed: isAnswered
                      ? () {
                          if (isComplete) {
                            widget.onComplete();
                          } else {
                            setState(() {
                              _currentIndex++;
                              _selectedAnswer = null;
                            });
                          }
                        }
                      : null,
                  icon: Icon(isComplete ? Icons.check : Icons.arrow_forward),
                  label: Text(isComplete ? 'Complete' : 'Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

