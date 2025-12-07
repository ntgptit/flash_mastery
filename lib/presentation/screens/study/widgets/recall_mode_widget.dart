import 'dart:async';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/strategies/study_strategies.dart';
import 'package:flutter/material.dart';

class RecallModeWidget extends StatefulWidget {
  final StudySession session;
  final List<Flashcard> flashcards;
  final VoidCallback onComplete;

  const RecallModeWidget({
    super.key,
    required this.session,
    required this.flashcards,
    required this.onComplete,
  });

  @override
  State<RecallModeWidget> createState() => _RecallModeWidgetState();
}

class _RecallModeWidgetState extends State<RecallModeWidget> {
  int _currentIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  int _timeRemaining = 30; // 30 seconds
  Timer? _timer;
  final Map<int, bool> _results = {};
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeRemaining = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeRemaining > 0 && !_isAnswered) {
            _timeRemaining--;
          } else {
            timer.cancel();
            if (_timeRemaining == 0 && !_isAnswered) {
              _checkAnswer();
            }
          }
        });
      }
    });
  }

  void _checkAnswer() {
    if (_isAnswered) return;

    final currentCard = widget.flashcards[_currentIndex];
    final handler = RecallStudyHandler();
    final isCorrect = handler.validateAnswer(
      flashcard: currentCard,
      userAnswer: _answerController.text,
    );

    setState(() {
      _isAnswered = true;
      _results[_currentIndex] = isCorrect;
    });
    _timer?.cancel();

    // Auto-advance to next card if answer is correct
    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          if (_currentIndex >= widget.flashcards.length - 1) {
            // All cards completed
            widget.onComplete();
          } else {
            setState(() {
              _currentIndex++;
              _answerController.clear();
              _isAnswered = false;
              _startTimer();
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return const Center(child: Text('No flashcards in this batch'));
    }

    final currentCard = widget.flashcards[_currentIndex];
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

          // Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentIndex + 1} / ${widget.flashcards.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: _timeRemaining <= 5
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                ),
                child: Text(
                  '$_timeRemaining s',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _timeRemaining <= 5
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Term displayed
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
                    'Term',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: Center(
                      child: Text(
                        currentCard.question,
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
              labelText: 'Type the meaning',
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
                  : null,
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
                        'Correct answer: ${currentCard.answer}',
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
        ],
      ),
    );
  }
}

