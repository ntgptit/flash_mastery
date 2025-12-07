import 'dart:async';
import 'dart:math';

import 'package:flash_mastery/core/core.dart';
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
  String? _wrongTermId; // ID of wrong term being highlighted
  String? _wrongMeaningId; // ID of wrong meaning being highlighted
  final Set<String> _correctMatchIds =
      {}; // IDs of cards showing correct match feedback before removal
  Timer? _wrongMatchTimer; // Timer to clear wrong match feedback
  late final List<Flashcard> _shuffledMeanings;

  @override
  void initState() {
    super.initState();
    // Shuffle meanings only once to avoid reordering each build
    _shuffledMeanings = List<Flashcard>.from(widget.flashcards)..shuffle(Random());
  }

  @override
  void dispose() {
    _wrongMatchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return const Center(child: Text('No flashcards in this batch'));
    }

    // Filter out matched cards (but include cards showing correct match feedback)
    final unmatchedTerms = widget.flashcards
        .where((f) => !_matches.containsKey(f.id) || _correctMatchIds.contains(f.id))
        .toList();
    final unmatchedMeanings = _shuffledMeanings
        .where((f) => !_matches.values.contains(f.id) || _correctMatchIds.contains(f.id))
        .toList();

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
              Expanded(child: _buildTermsColumn(unmatchedTerms)),
              const SizedBox(width: AppSpacing.md),
              // Meanings column
              Expanded(child: _buildMeaningsColumn(unmatchedMeanings)),
            ],
          ),
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
          final isSelected = _selectedTermId == card.id;
          final isWrongMatch = _wrongTermId == card.id;
          final isCorrectMatch = _correctMatchIds.contains(card.id);

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: () {
                setState(() {
                  // Clear any wrong match highlight when selecting new term
                  _wrongMatchTimer?.cancel();
                  _wrongTermId = null;
                  _wrongMeaningId = null;

                  // Deselect if clicking the same term again
                  if (_selectedTermId == card.id) {
                    _selectedTermId = null;
                    return;
                  }

                  // Select new term
                  _selectedTermId = card.id;
                  _selectedMeaningId = null;
                });
              },
              child: Container(
                height: 150, // Same height as meanings column
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isCorrectMatch
                      ? Theme.of(context).colorScheme.successContainer
                      : isWrongMatch
                      ? Theme.of(context).colorScheme.dangerousContainer
                      : isSelected
                      ? Theme.of(context).colorScheme.success.withOpacity(0.2)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  border: isCorrectMatch
                      ? Border.all(color: Theme.of(context).colorScheme.success, width: 2)
                      : isWrongMatch
                      ? Border.all(color: Theme.of(context).colorScheme.dangerous, width: 2)
                      : isSelected
                      ? Border.all(color: Theme.of(context).colorScheme.success, width: 2)
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
          final isSelected = _selectedMeaningId == card.id;
          final isWrongMatch = _wrongMeaningId == card.id;
          final isCorrectMatch = _correctMatchIds.contains(card.id);

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: () {
                // Clear any wrong match highlight and timer
                _wrongMatchTimer?.cancel();

                setState(() {
                  _wrongTermId = null;
                  _wrongMeaningId = null;

                  // Deselect if clicking the same meaning again
                  if (_selectedMeaningId == card.id) {
                    _selectedMeaningId = null;
                    return;
                  }

                  // Select this meaning
                  _selectedMeaningId = card.id;

                  // No term selected yet, just wait for user to select one
                  if (_selectedTermId == null) {
                    return;
                  }

                  // Check if match is correct
                  final termCard = widget.flashcards.firstWhere((f) => f.id == _selectedTermId);

                  // Correct match - show success highlight first
                  if (termCard.id == card.id) {
                    final matchedTermId = _selectedTermId!;
                    final matchedMeaningId = card.id;

                    _correctMatchIds.add(matchedTermId);
                    _correctMatchIds.add(matchedMeaningId);
                    _selectedTermId = null;
                    _selectedMeaningId = null;

                    // After showing success feedback, add to matches and remove from display
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          _matches[matchedTermId] = matchedMeaningId;
                          _correctMatchIds.clear();
                        });

                        // Check if all matches are complete
                        if (_matches.length == widget.flashcards.length) {
                          // Auto-advance to next mode after a brief delay
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              widget.onComplete();
                            }
                          });
                        }
                      }
                    });
                    return;
                  }

                  // Wrong match - show dangerous color feedback
                  _wrongTermId = _selectedTermId;
                  _wrongMeaningId = card.id;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect match. Try again.'),
                      duration: Duration(seconds: 1),
                    ),
                  );

                  // Auto clear wrong match after 1 second
                  _wrongMatchTimer = Timer(const Duration(milliseconds: 1000), () {
                    if (mounted) {
                      setState(() {
                        _selectedTermId = null;
                        _selectedMeaningId = null;
                        _wrongTermId = null;
                        _wrongMeaningId = null;
                      });
                    }
                  });
                });
              },
              child: Container(
                height: 150, // Taller height for meanings column due to longer text
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isCorrectMatch
                      ? Theme.of(context).colorScheme.successContainer
                      : isWrongMatch
                      ? Theme.of(context).colorScheme.dangerousContainer
                      : isSelected
                      ? Theme.of(context).colorScheme.success.withOpacity(0.2)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  border: isCorrectMatch
                      ? Border.all(color: Theme.of(context).colorScheme.success, width: 2)
                      : isWrongMatch
                      ? Border.all(color: Theme.of(context).colorScheme.dangerous, width: 2)
                      : isSelected
                      ? Border.all(color: Theme.of(context).colorScheme.success, width: 2)
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
