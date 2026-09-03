import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Base shimmer block. Tinted rose/ivory instead of default grey so
/// loading states still feel like the brand, not a generic skeleton.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 16, this.borderRadius});
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceBlush,
      highlightColor: AppColors.ivory,
      period: const Duration(milliseconds: 1400),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.white, borderRadius: borderRadius ?? AppRadius.mdRadius),
      ),
    );
  }
}

/// Loading placeholder shaped like a [VendorCard] for grids/carousels.
class SkeletonVendorCard extends StatelessWidget {
  const SkeletonVendorCard({super.key, this.width = 200});
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: width, height: 140, borderRadius: AppRadius.xlRadius),
          const SizedBox(height: 10),
          SkeletonBox(width: width * 0.7, height: 14),
          const SizedBox(height: 6),
          SkeletonBox(width: width * 0.45, height: 12),
        ],
      ),
    );
  }
}
