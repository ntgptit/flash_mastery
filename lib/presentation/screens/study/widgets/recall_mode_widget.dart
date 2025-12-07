import 'dart:async';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
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
  static const double _cardHeight = 200; // Fixed height for both Meaning and Term cards

  int _currentIndex = 0;
  int _timeRemaining = 30; // 30 seconds
  Timer? _timer;
  final Map<int, bool> _results = {};
  bool _isAnswerShown = false; // Whether user clicked "Show" button
  List<Flashcard> _notMasteredQueue = []; // Queue for flashcards not mastered
  List<Flashcard> _currentFlashcards = []; // Current flashcards being studied

  @override
  void initState() {
    super.initState();
    _currentFlashcards = List.from(widget.flashcards);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeRemaining = 30;
    _isAnswerShown = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeRemaining > 0 && !_isAnswerShown) {
            _timeRemaining--;
          } else {
            timer.cancel();
            if (_timeRemaining == 0 && !_isAnswerShown) {
              // Time's up - auto show answer and add to queue
              _showAnswer();
            }
          }
        });
      }
    });
  }

  void _showAnswer() {
    if (_isAnswerShown) return;

    setState(() {
      _isAnswerShown = true;
      _timer?.cancel();
      // Add to not mastered queue when time's up or shown manually
      final currentCard = _currentFlashcards[_currentIndex];
      if (!_notMasteredQueue.any((card) => card.id == currentCard.id)) {
        _notMasteredQueue.add(currentCard);
      }
    });
  }

  void _markAsRemembered() {
    final currentCard = _currentFlashcards[_currentIndex];
    // Remove from queue if it was there
    _notMasteredQueue.removeWhere((card) => card.id == currentCard.id);

    setState(() {
      _results[_currentIndex] = true;
    });

    // Move to next card
    _moveToNextCard();
  }

  void _markAsForgot() {
    final currentCard = _currentFlashcards[_currentIndex];
    // Ensure it's in the queue
    if (!_notMasteredQueue.any((card) => card.id == currentCard.id)) {
      _notMasteredQueue.add(currentCard);
    }

    // Move to next card
    _moveToNextCard();
  }

  void _moveToNextCard() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
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
              _isAnswerShown = false;
              _results.clear();
              _startTimer();
            });
          }
        } else {
          // Move to next card in current batch
          setState(() {
            _currentIndex++;
            _isAnswerShown = false;
            _startTimer();
          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_currentFlashcards.isEmpty) {
      return const Center(child: Text('No flashcards in this batch'));
    }

    final currentCard = _currentFlashcards[_currentIndex];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _currentFlashcards.length,
            minHeight: 4,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentIndex + 1} / ${_currentFlashcards.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (_notMasteredQueue.isNotEmpty)
                Text(
                  'Queue: ${_notMasteredQueue.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
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

          // Meaning displayed
          Card(
            elevation: 4,
            margin: EdgeInsets.zero, // Remove default card margin
            child: Container(
              height: _cardHeight, // Fixed height to match Term card
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
          // Term displayed (same design as Meaning) - shown when answer is revealed
          if (_isAnswerShown) ...[
            const SizedBox(height: AppSpacing.xl),
            Card(
              elevation: 4,
              margin: EdgeInsets.zero, // Remove default card margin
              child: Container(
                height: _cardHeight, // Fixed height to match Meaning card
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
          ],
          const Spacer(),

          // Show button at bottom center
          if (!_isAnswerShown && _timeRemaining > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: FilledButton.icon(
                onPressed: _showAnswer,
                icon: const Icon(Icons.visibility),
                label: const Text('Show'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ),

          // Remembered/Forgot buttons
          if (_isAnswerShown) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _markAsForgot,
                    icon: const Icon(Icons.close),
                    label: const Text('Forgot'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _markAsRemembered,
                    icon: const Icon(Icons.check),
                    label: const Text('Remembered'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

