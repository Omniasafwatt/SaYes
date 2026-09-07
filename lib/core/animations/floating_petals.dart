import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Decorative floating garden — small flower blossoms drifting among loose
/// petals — for splash/onboarding/hero backdrops. Every shape is drawn with
/// [CustomPainter] (no image assets, so no licensing to track), deliberately
/// low-opacity and slow: this is ambient texture, not a sticker. Purely
/// cosmetic: wrap content with a [Stack] and place this behind it —
/// `IgnorePointer` is applied internally.
class FloatingPetals extends StatefulWidget {
  const FloatingPetals({
    super.key,
    this.petalCount = 5,
    this.color = AppColors.primaryLight,
    this.accentColor = AppColors.gold,
    this.maxOpacity = 0.35,
  });

  final int petalCount;
  final Color color;

  /// Tint for each blossom's center — a small warm dot of contrast against
  /// the petals. Ignored for the loose single-petal shapes.
  final Color accentColor;
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
      final isBloom = random.nextDouble() < 0.55;
      return _PetalSpec(
        left: random.nextDouble(),
        top: random.nextDouble() * 0.8,
        size: isBloom ? 22 + random.nextDouble() * 22 : 16 + random.nextDouble() * 16,
        floatRange: 10 + random.nextDouble() * 14,
        phase: random.nextDouble() * math.pi * 2,
        speed: 0.6 + random.nextDouble() * 0.8,
        rotation: random.nextDouble() * math.pi,
        isBloom: isBloom,
        bloomPetals: 5 + random.nextInt(2),
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
                        child: Transform.scale(
                          scale: 0.92 + 0.08 * math.sin(t * spec.speed * 0.7 + spec.phase),
                          child: Opacity(
                            opacity: widget.maxOpacity *
                                (0.6 + 0.4 * math.sin(t * spec.speed + spec.phase).abs()),
                            child: CustomPaint(
                              size: Size.square(spec.size),
                              painter: spec.isBloom
                                  ? _BlossomPainter(color: widget.color, accentColor: widget.accentColor, petalCount: spec.bloomPetals)
                                  : _PetalPainter(color: widget.color),
                            ),
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
    required this.isBloom,
    required this.bloomPetals,
  });

  final double left; // fractional 0..1
  final double top; // fractional 0..1
  final double size;
  final double floatRange;
  final double phase;
  final double speed;
  final double rotation;
  final bool isBloom;
  final int bloomPetals;
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

/// A small radial flower blossom — [petalCount] soft teardrop petals fanned
/// evenly around a tinted center dot. Reuses the same petal silhouette as
/// [_PetalPainter], just smaller and rotated into a ring.
class _BlossomPainter extends CustomPainter {
  _BlossomPainter({required this.color, required this.accentColor, required this.petalCount});

  final Color color;
  final Color accentColor;
  final int petalCount;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final petalLength = size.width * 0.5;
    final petalWidth = size.width * 0.34;
    final petalPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var i = 0; i < petalCount; i++) {
      final angle = (2 * math.pi * i) / petalCount;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      final path = Path()
        ..moveTo(0, -petalLength * 0.1)
        ..cubicTo(petalWidth * 0.5, -petalLength * 0.45, petalWidth * 0.4, -petalLength * 0.95, 0, -petalLength)
        ..cubicTo(-petalWidth * 0.4, -petalLength * 0.95, -petalWidth * 0.5, -petalLength * 0.45, 0, -petalLength * 0.1);
      canvas.drawPath(path, petalPaint);
      canvas.restore();
    }

    canvas.drawCircle(center, size.width * 0.11, Paint()..color = accentColor);
  }

  @override
  bool shouldRepaint(covariant _BlossomPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.accentColor != accentColor || oldDelegate.petalCount != petalCount;
}
