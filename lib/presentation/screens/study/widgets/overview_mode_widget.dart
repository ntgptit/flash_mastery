import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flutter/material.dart';

class OverviewModeWidget extends StatefulWidget {
  final StudySession session;
  final List<Flashcard> flashcards;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  const OverviewModeWidget({
    super.key,
    required this.session,
    required this.flashcards,
    required this.onNext,
    required this.onComplete,
  });

  @override
  State<OverviewModeWidget> createState() => _OverviewModeWidgetState();
}

class _OverviewModeWidgetState extends State<OverviewModeWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return const Center(child: Text('No flashcards in this batch'));
    }

    final currentCard = widget.flashcards[_currentIndex];
    final isLastCard = _currentIndex >= widget.flashcards.length - 1;

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

          // Card count
          Text(
            '${_currentIndex + 1} / ${widget.flashcards.length}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Flashcard content
          Expanded(
            child: Card(
              elevation: 4,
              margin: EdgeInsets.zero, // Remove default card margin
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Meaning (answer) - displayed above
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
                    const SizedBox(height: AppSpacing.xl),

                    // Divider
                    const Divider(),
                    const SizedBox(height: AppSpacing.xl),

                    // Term (question) - displayed below
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
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                ),
              if (_currentIndex > 0) const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    if (isLastCard) {
                      widget.onComplete();
                    } else {
                      setState(() {
                        _currentIndex++;
                      });
                    }
                  },
                  icon: Icon(isLastCard ? Icons.check : Icons.arrow_forward),
                  label: Text(isLastCard ? 'Complete' : 'Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

