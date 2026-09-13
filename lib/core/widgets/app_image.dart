import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'skeleton.dart';

/// Remote image with shimmer placeholder + graceful error state. Nothing
/// in the app should call [Image.network] directly.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({super.key, required this.url, this.fit = BoxFit.cover, this.borderRadius, this.width, this.height});
  final String url;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, _) => SkeletonBox(width: width, height: height ?? 120, borderRadius: BorderRadius.zero),
      errorWidget: (context, _, error) => Container(
        width: width,
        height: height,
        color: AppColors.surfaceBlush,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_rounded, color: AppColors.textSecondary),
      ),
    );
    return borderRadius != null ? ClipRRect(borderRadius: borderRadius!, child: image) : image;
  }
}

/// Bundled/local image — the 12 Stitch photography assets and the logo.
class AppAssetImage extends StatelessWidget {
  const AppAssetImage({super.key, required this.path, this.fit = BoxFit.cover, this.borderRadius, this.width, this.height});
  final String path;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(path, fit: fit, width: width, height: height);
    return borderRadius != null ? ClipRRect(borderRadius: borderRadius!, child: image) : image;
  }
}

/// Renders [path] as a real network image when it looks like one, otherwise
/// as a bundled asset. Vendor photos are Cloudinary URLs once real data is
/// wired in, but the "no photo yet" fallback is a local asset — this lets
/// every gallery/grid that shows vendor imagery handle both through one
/// string field instead of each screen re-checking the scheme itself.
class AppSmartImage extends StatelessWidget {
  const AppSmartImage({super.key, required this.path, this.fit = BoxFit.cover, this.borderRadius, this.width, this.height});
  final String path;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    return isNetwork
        ? AppNetworkImage(url: path, fit: fit, borderRadius: borderRadius, width: width, height: height)
        : AppAssetImage(path: path, fit: fit, borderRadius: borderRadius, width: width, height: height);
  }
}
