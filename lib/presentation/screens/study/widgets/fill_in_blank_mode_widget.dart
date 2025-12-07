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
  List<Flashcard> _notMasteredQueue = []; // Queue for flashcards not mastered
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

    // Auto-advance to next card
    if (isCorrect) {
      // Correct answer - remove from queue if exists and move to next
      _notMasteredQueue.removeWhere((card) => card.id == currentCard.id);
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _moveToNextCard();
        }
      });
    } else {
      // Wrong answer - add to queue and move to next
      if (!_notMasteredQueue.any((card) => card.id == currentCard.id)) {
        _notMasteredQueue.add(currentCard);
      }
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _moveToNextCard();
        }
      });
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
          StudyCard(
            label: 'Meaning',
            content: currentCard.answer,
            height: 200,
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
                          ? Theme.of(context).colorScheme.success
                          : Theme.of(context).colorScheme.dangerous,
                    )
                  : IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: _checkAnswer,
                    ),
            ),
            onSubmitted: (_) => _checkAnswer(),
          ),

          if (_isAnswered) ...[
            const SizedBox(height: AppSpacing.xl),
            StudyResultCard(
              isCorrect: isCorrect,
              message: 'Correct answer: ${currentCard.question}',
            ),
          ],
        ],
      ),
    );
  }
}

