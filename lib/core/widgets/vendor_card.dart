import 'package:flutter/material.dart';
import '../animations/pressable_scale.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_image.dart';
import 'badges.dart';
import 'favorite_button.dart';

/// Standard vendor discovery card: image, name, verification, rating,
/// review count, city, starting price, favorite toggle, and an optional
/// featured indicator. Used on Home, Search results, and the vendor
/// listing screen so the visual language stays identical everywhere.
class VendorCard extends StatelessWidget {
  const VendorCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.city,
    required this.rating,
    required this.reviewCountLabel,
    required this.startingPriceLabel,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.isAssetImage = false,
    this.isVerified = false,
    this.verifiedLabel,
    this.isFeatured = false,
    this.featuredLabel,
    this.onTap,
    this.width = 220,
  });

  final String imageUrl;
  final bool isAssetImage;
  final String name;
  final String city;
  final double rating;
  final String reviewCountLabel;
  final String startingPriceLabel;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final bool isVerified;
  final String? verifiedLabel;
  final bool isFeatured;
  final String? featuredLabel;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.xlRadius, boxShadow: AppShadows.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                  child: isAssetImage
                      ? AppAssetImage(path: imageUrl, height: 150, width: width)
                      : AppNetworkImage(url: imageUrl, height: 150, width: width),
                ),
                if (isFeatured && featuredLabel != null)
                  PositionedDirectional(top: 10, start: 10, child: FeaturedBadge(label: featuredLabel!)),
                PositionedDirectional(
                  top: 10,
                  end: 10,
                  child: FavoriteButton(isFavorite: isFavorite, onToggle: onFavoriteToggle, size: 34),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPaddingSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(name, style: context.typography.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      if (isVerified && verifiedLabel != null) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified_rounded, size: 16, color: AppColors.gold),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(city, style: context.typography.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.gold),
                          const SizedBox(width: 3),
                          Text(rating.toStringAsFixed(1), style: context.typography.labelMd),
                          const SizedBox(width: 3),
                          Text(reviewCountLabel, style: context.typography.metadata),
                        ],
                      ),
                      Text(startingPriceLabel, style: context.typography.price.copyWith(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
