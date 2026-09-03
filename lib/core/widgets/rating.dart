import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 14, this.color = AppColors.gold, this.maxRating = 5});
  final double rating;
  final double size;
  final Color color;
  final int maxRating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (i) {
        final fraction = (rating - i).clamp(0, 1).toDouble();
        return Padding(
          padding: const EdgeInsets.only(right: 1),
          child: Stack(
            children: [
              Icon(Icons.star_rounded, size: size, color: AppColors.outlineNeutral),
              ClipRect(
                clipper: _FractionClipper(fraction),
                child: Icon(Icons.star_rounded, size: size, color: color),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _FractionClipper extends CustomClipper<Rect> {
  _FractionClipper(this.fraction);
  final double fraction;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(covariant _FractionClipper oldClipper) => oldClipper.fraction != fraction;
}

/// Big-number rating summary — "4.9 ★★★★★ 120 reviews". [reviewsLabel] is
/// passed in already localized/formatted by the caller.
class RatingSummary extends StatelessWidget {
  const RatingSummary({super.key, required this.rating, required this.reviewsLabel});
  final double rating;
  final String reviewsLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(rating.toStringAsFixed(1), style: context.typography.price),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingStars(rating: rating),
            const SizedBox(height: 2),
            Text(reviewsLabel, style: context.typography.metadata),
          ],
        ),
      ],
    );
  }
}
