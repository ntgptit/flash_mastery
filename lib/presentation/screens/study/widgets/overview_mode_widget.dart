import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/presentation/screens/study/widgets/common/study_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late PageController _pageController;
  int _currentIndex = 0;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _pageController.dispose();
    try {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
      _focusNode.dispose();
    } catch (e) {
      // FocusNode may already be disposed, ignore
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Auto-complete when reaching the last card
    if (index >= widget.flashcards.length - 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          widget.onComplete();
        }
      });
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.flashcards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _goToPrevious();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _goToNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return const Center(child: Text('No flashcards in this batch'));
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          StudyProgressIndicator(currentIndex: _currentIndex, totalCount: widget.flashcards.length),
          const SizedBox(height: AppSpacing.xl),

          // Flashcard content with swipe gesture
          Expanded(
            child: KeyboardListener(
              focusNode: _focusNode,
              onKeyEvent: _handleKeyEvent,
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  // Swipe left (negative velocity) = next card
                  // Swipe right (positive velocity) = previous card
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! < -500) {
                      // Swipe left - go to next
                      _goToNext();
                    } else if (details.primaryVelocity! > 500) {
                      // Swipe right - go to previous
                      _goToPrevious();
                    }
                  }
                },
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: widget.flashcards.length,
                  physics: const BouncingScrollPhysics(), // Better feel on web
                  itemBuilder: (context, index) {
                    final card = widget.flashcards[index];
                    return _buildFlashcardCard(context, card);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardCard(BuildContext context, Flashcard card) {
    return GestureDetector(
      onTap: () {
        // Focus the widget when tapped to enable keyboard navigation
        _focusNode.requestFocus();
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero, // Remove default card margin
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
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
                    card.answer,
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
                    card.question,
                    style: Theme.of(context).textTheme.bodyLarge, // No bold
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
