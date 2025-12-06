import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flutter/material.dart';

class FlashcardHeroCarousel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (cards.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: pageController,
            itemCount: cards.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Center(
                    child: Text(
                      card.question,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
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
          children: List.generate(cards.length, (i) {
            final isActive = i == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 10 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }
}
