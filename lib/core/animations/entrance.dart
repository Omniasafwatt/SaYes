import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'app_motion.dart';

enum EntranceDirection { up, down, left, right, none }

/// Standard "soft reveal" entrance: fade + slide (+ a touch of scale).
/// Use for page content, hero sections, and any single element that should
/// announce itself on first appearance.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppMotion.medium,
    this.direction = EntranceDirection.up,
    this.distance = 16,
    this.scaleFrom = 0.97,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final EntranceDirection direction;
  final double distance;
  final double scaleFrom;

  Offset get _beginOffset => switch (direction) {
        EntranceDirection.up => Offset(0, distance),
        EntranceDirection.down => Offset(0, -distance),
        EntranceDirection.left => Offset(distance, 0),
        EntranceDirection.right => Offset(-distance, 0),
        EntranceDirection.none => Offset.zero,
      };

  @override
  Widget build(BuildContext context) {
    var effect = child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: AppMotion.entrance)
        .scale(
          begin: Offset(scaleFrom, scaleFrom),
          end: const Offset(1, 1),
          duration: duration,
          curve: AppMotion.entrance,
        );
    if (direction != EntranceDirection.none) {
      effect = effect.move(
        begin: _beginOffset,
        end: Offset.zero,
        duration: duration,
        curve: AppMotion.entrance,
      );
    }
    return effect;
  }
}

/// Wraps a list of widgets so each one enters with an incrementally later
/// delay — the "staggered card appearance" pattern used across grids,
/// carousels, and vertical lists.
extension StaggeredEntrance on List<Widget> {
  List<Widget> staggeredEntrance({
    EntranceDirection direction = EntranceDirection.up,
    Duration step = AppMotion.staggerStep,
    Duration baseDelay = Duration.zero,
  }) {
    return [
      for (final (index, widget) in indexed)
        FadeSlideIn(
          delay: baseDelay + step * index.clamp(0, AppMotion.staggerCap),
          direction: direction,
          child: widget,
        ),
    ];
  }
}
