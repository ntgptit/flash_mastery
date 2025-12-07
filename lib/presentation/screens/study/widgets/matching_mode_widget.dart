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
  final Set<String> _wrongMatchIds = {}; // IDs for the single wrong pair being highlighted
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

  void _setWrongPair(String termId, String meaningId) {
    // Ensure only one pair is highlighted at a time
    _wrongMatchTimer?.cancel();
    setState(() {
      _wrongMatchIds
        ..clear()
        ..add(termId)
        ..add(meaningId);
    });
    _wrongMatchTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _clearWrongMatch();
      }
    });
  }

  void _clearWrongMatch() {
    _wrongMatchTimer?.cancel();
    setState(() {
      _selectedTermId = null;
      _selectedMeaningId = null;
      _wrongMatchIds.clear();
    });
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
          final isWrongMatch = _wrongMatchIds.contains(card.id);
          final isCorrectMatch = _correctMatchIds.contains(card.id);

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (_selectedTermId == card.id) {
                    _selectedTermId = null;
                  } else {
                    _selectedTermId = card.id;
                    _selectedMeaningId = null;
                    _wrongMatchTimer?.cancel(); // Cancel any pending wrong match clear
                    _wrongMatchIds.clear(); // Clear wrong match feedback when selecting new term
                  }
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
          final isWrongMatch = _wrongMatchIds.contains(card.id);
          final isCorrectMatch = _correctMatchIds.contains(card.id);

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (_selectedMeaningId == card.id) {
                    _selectedMeaningId = null;
                    _wrongMatchIds.clear(); // Clear wrong match when deselecting
                  } else {
                    // Cancel any pending wrong match clear timer
                    _wrongMatchTimer?.cancel();
                    // Always clear wrong match when selecting a new meaning
                    _wrongMatchIds.clear();
                    _selectedMeaningId = card.id;

                    if (_selectedTermId != null) {
                      // Check if match is correct
                      final termCard = widget.flashcards.firstWhere((f) => f.id == _selectedTermId);
                      if (termCard.id == card.id) {
                        // Correct match - show success highlight first
                        final matchedTermId = _selectedTermId!;
                        final matchedMeaningId = card.id;

                        setState(() {
                          _correctMatchIds.add(matchedTermId);
                          _correctMatchIds.add(matchedMeaningId);
                          _selectedTermId = null;
                          _selectedMeaningId = null;
                          _wrongMatchIds.clear();
                        });

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
                      } else {
                        // Wrong match - show dangerous color feedback for only this pair
                        // Ensure only 1 pair is highlighted by clearing first
                        _setWrongPair(_selectedTermId!, card.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Incorrect match. Try again.'),
                            duration: Duration(seconds: 1),
                          ),
                        );

                        // Reset selection and clear wrong match feedback after delay
                        _wrongMatchTimer = Timer(const Duration(milliseconds: 1000), () {
                          if (mounted) {
                            _clearWrongMatch();
                          }
                        });
                      }
                    }
                  }
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
