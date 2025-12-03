import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// A reusable loading widget with various styles
class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;
  final LoadingStyle style;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size = AppSpacing.loaderSizeDefault,
    this.style = LoadingStyle.circular,
  });

  @override
  Widget build(BuildContext context) {
    final loadingColor = color ?? Theme.of(context).colorScheme.primary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLoadingIndicator(loadingColor),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(Color loadingColor) {
    switch (style) {
      case LoadingStyle.circular:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
            strokeWidth: AppSpacing.strokeWidthRegular,
          ),
        );
      case LoadingStyle.linear:
        return SizedBox(
          width: size * AppAnimation.linearLoadingWidthFactor,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
          ),
        );
      case LoadingStyle.dots:
        return _DotsLoadingIndicator(color: loadingColor, size: size);
    }
  }
}

/// Different styles for loading indicator
enum LoadingStyle {
  circular,
  linear,
  dots,
}

/// Custom dots loading indicator
class _DotsLoadingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const _DotsLoadingIndicator({
    required this.color,
    required this.size,
  });

  @override
  State<_DotsLoadingIndicator> createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<_DotsLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimation.loadingDotsDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size / AppAnimation.loadingDotsHeightFactor,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(AppAnimation.loadingDotsCount, (index) {
              final delay = index * AppAnimation.loadingDotsDelayInterval;
              final normalizedValue =
                  (_controller.value - delay)
                      .clamp(AppAnimation.loadingProgressMin, AppAnimation.loadingProgressMax);

              final progressWithinHalf =
                  normalizedValue < AppAnimation.loadingDotsHalfCycle
                      ? normalizedValue / AppAnimation.loadingDotsHalfCycle
                      : (AppAnimation.loadingProgressMax - normalizedValue) /
                          AppAnimation.loadingDotsHalfCycle;

              final scaleValue = AppAnimation.loadingDotsBaseScale +
                  (AppAnimation.loadingDotsScaleRange * progressWithinHalf);
              final effectiveOpacity =
                  AppOpacity.mediumHigh + (AppOpacity.mediumHigh * progressWithinHalf);

              return Transform.scale(
                scale: scaleValue,
                child: Container(
                  width: widget.size / AppAnimation.loadingDotsCircleFactor,
                  height: widget.size / AppAnimation.loadingDotsCircleFactor,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: effectiveOpacity),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

/// Overlay loading widget that covers the entire screen
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ??
                Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: AppOpacity.overlay),
            child: LoadingWidget(message: message),
          ),
      ],
    );
  }
}
