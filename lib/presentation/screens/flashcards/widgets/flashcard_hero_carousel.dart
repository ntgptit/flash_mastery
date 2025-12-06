import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FlashcardHeroCarousel extends StatefulWidget {
  final List<Flashcard> cards;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const FlashcardHeroCarousel({
    super.key,
    required this.cards,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  State<FlashcardHeroCarousel> createState() => _FlashcardHeroCarouselState();
}

class _FlashcardHeroCarouselState extends State<FlashcardHeroCarousel> {
  bool _showBack = false;

  void _toggleFace() {
    setState(() => _showBack = !_showBack);
  }

  Widget _buildPageIndicator(ColorScheme colorScheme) {
    final totalDots = widget.cards.length;
    const maxVisibleDots = 7;

    // If we have fewer dots than max, show all
    if (totalDots <= maxVisibleDots) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalDots, (i) {
          final isActive = i == widget.currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 10 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }),
      );
    }

    // For many dots, show a subset with current page in center
    final List<int> visibleIndices = [];
    final halfVisible = maxVisibleDots ~/ 2;

    int start = widget.currentPage - halfVisible;
    int end = widget.currentPage + halfVisible;

    // Adjust if we're near the start
    if (start < 0) {
      end += start.abs();
      start = 0;
    }

    // Adjust if we're near the end
    if (end >= totalDots) {
      start -= (end - totalDots + 1);
      end = totalDots - 1;
      if (start < 0) start = 0;
    }

    for (int i = start; i <= end; i++) {
      visibleIndices.add(i);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (start > 0) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(width: 2),
        ],
        ...visibleIndices.map((i) {
          final isActive = i == widget.currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 10 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }),
        if (end < totalDots - 1) ...[
          const SizedBox(width: 2),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 260,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: PageView.builder(
              controller: widget.pageController,
              itemCount: widget.cards.length,
              onPageChanged: (page) {
                setState(() => _showBack = false);
                widget.onPageChanged(page);
              },
              itemBuilder: (context, index) {
              final card = widget.cards[index];
              final isCurrent = index == widget.currentPage;
              final displayBack = _showBack && isCurrent;
              final textTheme = Theme.of(context).textTheme;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: GestureDetector(
                  onTap: _toggleFace,
                  onDoubleTap: _toggleFace,
                  onVerticalDragEnd: (_) => _toggleFace(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, anim) {
                          final slide = Tween<Offset>(
                            begin: const Offset(0.15, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));
                          return FadeTransition(
                            opacity: anim,
                            child: SlideTransition(position: slide, child: child),
                          );
                        },
                        child: Column(
                          key: ValueKey<bool>(displayBack),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              displayBack ? card.answer : card.question,
                              style: displayBack
                                  ? textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                                  : textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (displayBack && (card.hint ?? '').isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                card.hint ?? '',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildPageIndicator(colorScheme),
      ],
    );
  }
}
