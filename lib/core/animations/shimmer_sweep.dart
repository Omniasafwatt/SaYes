import 'package:flutter/material.dart';
import 'app_motion.dart';

/// Slow, continuous diagonal light sweep across [child] — the highlight
/// band travels well outside the widget's bounds on either side, so most of
/// each [AppMotion.shimmerCycle] it's invisible and only glints across
/// briefly. Used sparingly (primary CTA, hero surfaces) to read as premium
/// ambience rather than a busy loading shimmer.
class ShimmerSweep extends StatefulWidget {
  const ShimmerSweep({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.opacity = 0.35,
  });

  final Widget child;
  final Color color;
  final double opacity;

  @override
  State<ShimmerSweep> createState() => _ShimmerSweepState();
}

class _ShimmerSweepState extends State<ShimmerSweep> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: AppMotion.shimmerCycle)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Passthrough keeps whatever constraints this widget was given flowing
      // straight to [child] unchanged — the default StackFit.loose would
      // loosen a tight width (e.g. AppButton's full-width expand) and let
      // the child collapse to its intrinsic size while this overlay stayed
      // full-width, badly misaligning the sweep with the thing it sweeps.
      fit: StackFit.passthrough,
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRect(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final height = constraints.maxHeight;
                      final band = width * 0.5;
                      final travel = width + band * 2;
                      final x = -band + travel * _controller.value;
                      return Transform.translate(
                        offset: Offset(x, 0),
                        child: Transform.rotate(
                          angle: -0.35,
                          child: Container(
                            width: band,
                            height: height * 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.color.withValues(alpha: 0),
                                  widget.color.withValues(alpha: widget.opacity),
                                  widget.color.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
