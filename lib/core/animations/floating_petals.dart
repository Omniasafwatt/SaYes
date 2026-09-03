import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Decorative floating petal silhouettes for splash/onboarding/success
/// backdrops. Deliberately thin-stroked and low-opacity — this is ambient
/// texture, not a sticker. Purely cosmetic: wrap content with [Stack] and
/// place this behind it, `IgnorePointer` is applied internally.
class FloatingPetals extends StatefulWidget {
  const FloatingPetals({
    super.key,
    this.petalCount = 5,
    this.color = AppColors.primaryLight,
    this.maxOpacity = 0.35,
  });

  final int petalCount;
  final Color color;
  final double maxOpacity;

  @override
  State<FloatingPetals> createState() => _FloatingPetalsState();
}

class _FloatingPetalsState extends State<FloatingPetals> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_PetalSpec> _specs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    final random = math.Random(42); // stable layout across rebuilds
    _specs = List.generate(widget.petalCount, (i) {
      return _PetalSpec(
        left: random.nextDouble(),
        top: random.nextDouble() * 0.8,
        size: 18 + random.nextDouble() * 20,
        floatRange: 10 + random.nextDouble() * 14,
        phase: random.nextDouble() * math.pi * 2,
        speed: 0.6 + random.nextDouble() * 0.8,
        rotation: random.nextDouble() * math.pi,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final t = _controller.value * math.pi * 2;
              return Stack(
                children: [
                  for (final spec in _specs)
                    Positioned(
                      left: spec.left * constraints.maxWidth,
                      top: spec.top * constraints.maxHeight +
                          math.sin(t * spec.speed + spec.phase) * spec.floatRange,
                      child: Transform.rotate(
                        angle: spec.rotation + math.sin(t * spec.speed * 0.5 + spec.phase) * 0.25,
                        child: Opacity(
                          opacity: widget.maxOpacity *
                              (0.6 + 0.4 * math.sin(t * spec.speed + spec.phase).abs()),
                          child: CustomPaint(
                            size: Size.square(spec.size),
                            painter: _PetalPainter(color: widget.color),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _PetalSpec {
  _PetalSpec({
    required this.left,
    required this.top,
    required this.size,
    required this.floatRange,
    required this.phase,
    required this.speed,
    required this.rotation,
  });

  final double left; // fractional 0..1
  final double top; // fractional 0..1
  final double size;
  final double floatRange;
  final double phase;
  final double speed;
  final double rotation;
}

/// A single delicate, thin-stroked petal outline — echoes the SVG petal
/// silhouettes in the Stitch splash mockup, redrawn as a CustomPainter so
/// it scales cleanly without shipping SVG assets for something this simple.
class _PetalPainter extends CustomPainter {
  _PetalPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(w * 0.5, h * 0.05);
    path.cubicTo(w * 0.95, h * 0.25, w * 0.85, h * 0.85, w * 0.5, h * 0.95);
    path.cubicTo(w * 0.15, h * 0.85, w * 0.05, h * 0.25, w * 0.5, h * 0.05);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PetalPainter oldDelegate) => oldDelegate.color != color;
}
