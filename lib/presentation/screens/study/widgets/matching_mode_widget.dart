import 'dart:math';

import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flutter/material.dart';

class MatchingModeWidget extends StatefulWidget {
  final StudySession session;
  final List<Flashcard> flashcards;
  final VoidCallback onComplete;

  const MatchingModeWidget({
    super.key,
    required this.session,
    required this.flashcards,
    required this.onComplete,
  });

  @override
  State<MatchingModeWidget> createState() => _MatchingModeWidgetState();
}

class _MatchingModeWidgetState extends State<MatchingModeWidget> {
  String? _selectedTermId;
  String? _selectedMeaningId;
  final Map<String, String> _matches = {}; // termId -> meaningId

  @override
  void initState() {
    super.initState();
    // Shuffle flashcards for matching
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return const Center(child: Text('No flashcards in this batch'));
    }

    final terms = widget.flashcards.map((f) => f).toList();
    final meanings = List<Flashcard>.from(widget.flashcards)..shuffle(Random());

    final isComplete = _matches.length == widget.flashcards.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text('Match terms with their meanings', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Matches: ${_matches.length} / ${widget.flashcards.length}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Terms column
              Expanded(child: _buildTermsColumn(terms)),
              const SizedBox(width: AppSpacing.md),
              // Meanings column
              Expanded(child: _buildMeaningsColumn(meanings)),
            ],
          ),

          if (isComplete) ...[
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: widget.onComplete,
              icon: const Icon(Icons.check),
              label: const Text('Continue'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTermsColumn(List<Flashcard> terms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Terms', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.md),
        ...terms.map((card) {
          final isMatched = _matches.containsKey(card.id);
          final isSelected = _selectedTermId == card.id;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: isMatched
                  ? null
                  : () {
                      setState(() {
                        if (_selectedTermId == card.id) {
                          _selectedTermId = null;
                        } else {
                          _selectedTermId = card.id;
                          _selectedMeaningId = null;
                        }
                      });
                    },
              child: Container(
                height: 150, // Same height as meanings column
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isMatched
                      ? Theme.of(context).colorScheme.primaryContainer
                      : isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  border: isSelected
                      ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          card.question,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    if (isMatched)
                      Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMeaningsColumn(List<Flashcard> meanings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Meanings',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        ...meanings.map((card) {
          final isMatched = _matches.values.contains(card.id);
          final isSelected = _selectedMeaningId == card.id;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: isMatched
                  ? null
                  : () {
                      setState(() {
                        if (_selectedMeaningId == card.id) {
                          _selectedMeaningId = null;
                        } else {
                          _selectedMeaningId = card.id;
                          if (_selectedTermId != null) {
                            // Check if match is correct
                            final termCard = widget.flashcards.firstWhere(
                              (f) => f.id == _selectedTermId,
                            );
                            if (termCard.id == card.id) {
                              // Correct match
                              _matches[_selectedTermId!] = card.id;
                              _selectedTermId = null;
                              _selectedMeaningId = null;
                            } else {
                              // Wrong match - show error briefly
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Incorrect match. Try again.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              _selectedTermId = null;
                              _selectedMeaningId = null;
                            }
                          }
                        }
                      });
                    },
              child: Container(
                height: 150, // Taller height for meanings column due to longer text
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isMatched
                      ? Theme.of(context).colorScheme.primaryContainer
                      : isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  border: isSelected
                      ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          card.answer,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    if (isMatched)
                      Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
