import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FlashcardHeroCarousel extends StatefulWidget {
  final List<Flashcard> cards;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final VoidCallback? onLoadMore;

  const FlashcardHeroCarousel({
    super.key,
    required this.cards,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    this.onLoadMore,
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

                // Trigger load more when user reaches second-to-last card
                if (widget.onLoadMore != null && page >= widget.cards.length - 2) {
                  widget.onLoadMore!();
                }
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
                    child: Stack(
                      children: [
                        // Speaker button at top right (only visible on mobile)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: AudioSpeakerButton(
                            text: displayBack ? card.answer : card.question,
                            iconColor: colorScheme.primary,
                          ),
                        ),
                        // Card content
                        Center(
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
                                      ? textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                                      : textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (displayBack && (card.hint ?? '').isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    card.hint ?? '',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        FmPageIndicator(
          itemCount: widget.cards.length,
          currentIndex: widget.currentPage,
        ),
      ],
    );
  }
}
