import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Thin decorative garland line — a wavy stroke with a few small leaf
/// accents and a center dot. Used under the splash wordmark and other
/// quiet "editorial pause" moments. Deliberately understated, matching the
/// brief's "delicate, thin, premium" floral direction.
class BotanicalDivider extends StatelessWidget {
  const BotanicalDivider({super.key, this.width = 190, this.height = 22, this.color = AppColors.roseGold});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _GarlandPainter(color: color),
    );
  }
}

class _GarlandPainter extends CustomPainter {
  _GarlandPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(w * 0.05, h * 0.5)
      ..cubicTo(w * 0.2, h * 0.15, w * 0.35, h * 0.85, w * 0.5, h * 0.5)
      ..cubicTo(w * 0.65, h * 0.15, w * 0.8, h * 0.85, w * 0.95, h * 0.5);
    canvas.drawPath(path, linePaint);

    final leafPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    for (final fx in [0.22, 0.38, 0.62, 0.78]) {
      final cx = w * fx;
      final cy = h * (fx < 0.5 ? 0.32 : 0.68);
      final leaf = Path()
        ..moveTo(cx, cy - 3)
        ..quadraticBezierTo(cx + 4, cy, cx, cy + 3)
        ..quadraticBezierTo(cx - 4, cy, cx, cy - 3);
      canvas.drawPath(leaf, leafPaint);
    }

    canvas.drawCircle(Offset(w / 2, h / 2), 2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _GarlandPainter oldDelegate) => oldDelegate.color != color;
}
