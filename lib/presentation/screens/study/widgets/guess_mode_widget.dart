import 'package:flash_mastery/core/core.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/factories/study_mode_factory.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/common/study_card.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/common/study_progress_indicator.dart';
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
  final Map<int, List<String>> _cachedOptions = {}; // index -> options (to prevent reshuffling)

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return const Center(child: Text('No flashcards in this batch'));
    }

    final currentCard = widget.flashcards[_currentIndex];
    final handler = StudyModeFactory.createHandler(widget.session.currentMode);

    // Cache options for each card index to prevent reshuffling after selection
    List<String> options;
    if (_cachedOptions.containsKey(_currentIndex)) {
      options = _cachedOptions[_currentIndex]!;
    } else {
      final generatedOptions =
          handler.getOptions(flashcard: currentCard, allFlashcards: widget.allFlashcards) ?? [];
      _cachedOptions[_currentIndex] = generatedOptions;
      options = generatedOptions;
    }

    final isCorrect = _results[_currentIndex] == true; // Only true if answered correctly

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          StudyProgressIndicator(currentIndex: _currentIndex, totalCount: widget.flashcards.length),
          const SizedBox(height: AppSpacing.xl),

          // Term displayed
          StudyCard(
            label: 'Term',
            content: currentCard.question,
            height: 250,
            contentStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 22,
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
                final isOptionCorrect = option == currentCard.answer;
                final showResult = isSelected && _selectedAnswer != null;
                final wasWrong = showResult && !isOptionCorrect;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: InkWell(
                    onTap: isCorrect
                        ? null // Disable only if already answered correctly
                        : () {
                            setState(() {
                              _selectedAnswer = option;
                              final isCorrectAnswer = handler.validateAnswer(
                                flashcard: currentCard,
                                userAnswer: option,
                              );

                              // Only save result and advance if answer is correct
                              if (isCorrectAnswer) {
                                _results[_currentIndex] = true;
                                // Auto-advance to next card if answer is correct
                                Future.delayed(const Duration(milliseconds: 1000), () {
                                  if (mounted) {
                                    if (_currentIndex >= widget.flashcards.length - 1) {
                                      // All cards completed
                                      widget.onComplete();
                                    } else {
                                      setState(() {
                                        _currentIndex++;
                                        _selectedAnswer = null;
                                        // Options for new card will be generated on next build
                                      });
                                    }
                                  }
                                });
                              } else {
                                // Wrong answer - show feedback but allow retry
                                // Don't save result, allow user to try again
                              }
                            });
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: showResult
                            ? (isOptionCorrect
                                  ? Theme.of(context).colorScheme.successContainer
                                  : Theme.of(context).colorScheme.dangerousContainer)
                            : isSelected
                            ? Theme.of(context).colorScheme.success.withAlpha(51)
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                        border: isSelected
                            ? Border.all(
                                color: wasWrong
                                    ? Theme.of(context).colorScheme.dangerous
                                    : Theme.of(context).colorScheme.success,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: Theme.of(context).textTheme.bodyMedium, // Reduced font size
                            ),
                          ),
                          if (showResult)
                            Icon(
                              isOptionCorrect ? Icons.check_circle : Icons.cancel,
                              color: isOptionCorrect
                                  ? Theme.of(context).colorScheme.success
                                  : Theme.of(context).colorScheme.dangerous,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
