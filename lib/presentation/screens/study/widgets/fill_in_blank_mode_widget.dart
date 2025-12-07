import 'package:flash_mastery/core/core.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/strategies/study_strategies.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/common/study_card.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/common/study_progress_indicator.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/common/study_result_card.dart';
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
  final List<Flashcard> _notMasteredQueue = []; // Queue for flashcards not mastered
  List<Flashcard> _currentFlashcards = []; // Current flashcards being studied

  @override
  void initState() {
    super.initState();
    _currentFlashcards = List.from(widget.flashcards);
  }

  void _checkAnswer() {
    if (_isAnswered) return;

    final currentCard = _currentFlashcards[_currentIndex];
    final handler = FillInBlankStudyHandler();
    final isCorrect = handler.validateAnswer(
      flashcard: currentCard,
      userAnswer: _answerController.text,
    );

    setState(() {
      _isAnswered = true;
      _results[_currentIndex] = isCorrect;
    });

    // Auto-advance only for correct answer
    if (isCorrect) {
      // Correct answer - remove from queue if exists and move to next
      _notMasteredQueue.removeWhere((card) => card.id == currentCard.id);
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _moveToNextCard();
        }
      });
    } else {
      // Wrong answer - add to queue, but DON'T auto-advance
      // User must click "Continue" button to proceed
      if (!_notMasteredQueue.any((card) => card.id == currentCard.id)) {
        _notMasteredQueue.add(currentCard);
      }
    }
  }

  void _moveToNextCard() {
    if (_currentIndex >= _currentFlashcards.length - 1) {
      // Finished current batch - check if queue has items
      if (_notMasteredQueue.isEmpty) {
        // No more cards to study - complete mode
        widget.onComplete();
      } else {
        // Start studying from queue
        setState(() {
          _currentFlashcards = List.from(_notMasteredQueue);
          _notMasteredQueue.clear();
          _currentIndex = 0;
          _answerController.clear();
          _isAnswered = false;
          _results.clear();
        });
      }
    } else {
      // Move to next card in current batch
      setState(() {
        _currentIndex++;
        _answerController.clear();
        _isAnswered = false;
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentFlashcards.isEmpty) {
      return const Center(child: Text('No flashcards in this batch'));
    }

    final currentCard = _currentFlashcards[_currentIndex];
    final isCorrect = _results[_currentIndex] ?? false;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          StudyProgressIndicator(
            currentIndex: _currentIndex,
            totalCount: _currentFlashcards.length,
            queueCount: _notMasteredQueue.isNotEmpty ? _notMasteredQueue.length : null,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Meaning displayed
          StudyCard(label: 'Meaning', content: currentCard.answer, height: 200),
          const SizedBox(height: AppSpacing.xl),

          // Answer input - hide when answered
          if (!_isAnswered)
            TextField(
              controller: _answerController,
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
                suffixIcon: IconButton(icon: const Icon(Icons.check), onPressed: _checkAnswer),
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),

          if (_isAnswered) ...[
            const SizedBox(height: AppSpacing.xl),
            if (isCorrect)
              StudyResultCard(isCorrect: true, message: 'Correct!')
            else ...[
              // Show term with highlighted errors
              _buildTermCardWithErrors(currentCard),
              const Spacer(),
              // Continue button at bottom
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _moveToNextCard,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTermCardWithErrors(Flashcard currentCard) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(color: Theme.of(context).colorScheme.dangerous, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Correct Answer',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildHighlightedAnswer(
            userAnswer: _answerController.text,
            correctAnswer: currentCard.question,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedAnswer({required String userAnswer, required String correctAnswer}) {
    final userChars = userAnswer.toLowerCase().split('');
    final correctChars = correctAnswer.toLowerCase().split('');
    final maxLength = correctAnswer.length;

    final List<TextSpan> spans = [];

    for (int i = 0; i < maxLength; i++) {
      final correctChar = correctAnswer[i];
      final isWrong = i >= userChars.length || userChars[i] != correctChars[i];

      spans.add(
        TextSpan(
          text: correctChar,
          style: TextStyle(
            color: isWrong
                ? Theme.of(context).colorScheme.dangerous
                : Theme.of(context).colorScheme.onSurface,
            backgroundColor: isWrong
                ? Theme.of(context).colorScheme.dangerous.withValues(alpha: 0.2)
                : null,
            fontWeight: isWrong ? FontWeight.bold : FontWeight.normal,
            fontSize: 20,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(children: spans, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
