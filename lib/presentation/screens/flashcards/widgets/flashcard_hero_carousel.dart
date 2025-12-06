import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
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

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 260,
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
                  onHorizontalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0;
                    if (velocity.abs() < 50) return;
                    _toggleFace();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
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
                              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            if (displayBack && (card.hint ?? '').isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                card.hint ?? '',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
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
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.cards.length, (i) {
            final isActive = i == widget.currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 10 : 6,
              height: 6,
              decoration: BoxDecoration(
                color:
                    isActive ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }
}
