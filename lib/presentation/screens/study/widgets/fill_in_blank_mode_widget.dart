import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/strategies/study_strategies.dart';
import 'package:flutter/material.dart';

class FillInBlankModeWidget extends StatefulWidget {
  final StudySession session;
  final List<Flashcard> flashcards;
  final VoidCallback onComplete;

  const FillInBlankModeWidget({
    super.key,
    required this.session,
    required this.flashcards,
    required this.onComplete,
  });

  @override
  State<FillInBlankModeWidget> createState() => _FillInBlankModeWidgetState();
}

class _FillInBlankModeWidgetState extends State<FillInBlankModeWidget> {
  int _currentIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  final Map<int, bool> _results = {};
  bool _isAnswered = false;

  void _checkAnswer() {
    if (_isAnswered) return;

    final currentCard = widget.flashcards[_currentIndex];
    final handler = FillInBlankStudyHandler();
    final isCorrect = handler.validateAnswer(
      flashcard: currentCard,
      userAnswer: _answerController.text,
    );

    setState(() {
      _isAnswered = true;
      _results[_currentIndex] = isCorrect;
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return const Center(child: Text('No flashcards in this batch'));
    }

    final currentCard = widget.flashcards[_currentIndex];
    final isComplete = _currentIndex >= widget.flashcards.length - 1 && _isAnswered;
    final isCorrect = _results[_currentIndex] ?? false;

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
            margin: EdgeInsets.zero, // Remove default card margin
            child: Container(
              height: 200, // Fixed height to prevent layout shifts
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meaning',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: Center(
                      child: Text(
                        currentCard.answer,
                        style: Theme.of(context).textTheme.bodyLarge, // No bold
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Answer input
          TextField(
            controller: _answerController,
            enabled: !_isAnswered,
            decoration: InputDecoration(
              labelText: 'Type the term',
              hintText: 'Enter your answer',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              ),
              suffixIcon: _isAnswered
                  ? Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    )
                  : IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: _checkAnswer,
                    ),
            ),
            onSubmitted: (_) => _checkAnswer(),
          ),

          if (_isAnswered) ...[
            const SizedBox(height: AppSpacing.md),
            // Show correct answer
            Card(
              color: isCorrect
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Correct answer: ${currentCard.question}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isCorrect
                                  ? Theme.of(context).colorScheme.onPrimaryContainer
                                  : Theme.of(context).colorScheme.onErrorContainer,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const Spacer(),

          // Navigation buttons
          Row(
            children: [
              if (_currentIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentIndex--;
                        _answerController.clear();
                        _isAnswered = false;
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                ),
              if (_currentIndex > 0) const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _isAnswered
                      ? () {
                          if (isComplete) {
                            widget.onComplete();
                          } else {
                            setState(() {
                              _currentIndex++;
                              _answerController.clear();
                              _isAnswered = false;
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

