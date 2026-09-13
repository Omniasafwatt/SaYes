import 'package:flutter/material.dart';

/// A placeholder image for the rare vendor with neither an avatar nor any
/// portfolio photos yet — should be uncommon on real, seeded data, but the
/// UI needs *something* to lay out rather than crash on a missing image.
const kFallbackVendorImage = 'assets/images/samantha-gades-CsrwM-bHQIg-unsplash.jpg';

/// "3 weeks ago" style relative time for a review's [ReviewModel.dateLabel]
/// — the API gives back a real `createdAt` timestamp, not pre-formatted
/// text, so something on the client has to do this; it lives here rather
/// than in the widget layer so every reviewer avoids re-implementing it.
String relativeTimeLabel(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inDays >= 365) {
    final years = (diff.inDays / 365).floor();
    return years == 1 ? '1 year ago' : '$years years ago';
  }
  if (diff.inDays >= 30) {
    final months = (diff.inDays / 30).floor();
    return months == 1 ? '1 month ago' : '$months months ago';
  }
  if (diff.inDays >= 7) {
    final weeks = (diff.inDays / 7).floor();
    return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
  }
  if (diff.inDays >= 1) return diff.inDays == 1 ? '1 day ago' : '${diff.inDays} days ago';
  if (diff.inHours >= 1) return diff.inHours == 1 ? '1 hour ago' : '${diff.inHours} hours ago';
  return 'Just now';
}

/// Whether a [VendorSummary.imageAsset]/[VendorDetail.imageAssets] entry is
/// a real Cloudinary URL (render with [AppNetworkImage]) rather than one of
/// the bundled local fallback assets (render with [AppAssetImage]).
bool isNetworkImage(String path) => path.startsWith('http://') || path.startsWith('https://');

int _roundedPrice(dynamic price) {
  if (price is num) return price.round();
  return double.tryParse(price?.toString() ?? '0')?.round() ?? 0;
}

/// Vendor card data for listing surfaces (Home carousels, Search results,
/// and the Vendor Listing screen). A fuller [VendorDetail] model backs the
/// Vendor Details screen; this is intentionally the slice a listing card
/// needs.
class VendorSummary {
  const VendorSummary({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.city,
    required this.categoryId,
    required this.rating,
    required this.reviewCount,
    required this.startingPriceEgp,
    this.isVerified = false,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String imageAsset;
  final String city;
  final String categoryId;
  final double rating;
  final int reviewCount;
  final int startingPriceEgp;
  final bool isVerified;
  final bool isFeatured;

  /// Maps the API's vendor shape — `{id, categoryId, city, avatarUrl,
  /// rating, reviewCount, isVerified, user:{name,...}, category:{id,...},
  /// portfolioItems:[...], packages:[...]}` — onto the client's card model.
  /// The API has no vendor-level `name` (it's the account's own `user.name`)
  /// and no `startingPriceEgp` (derived here as the cheapest package) or
  /// `isFeatured` flag (approximated as "verified and highly rated," since
  /// nothing server-side marks a vendor as featured).
  factory VendorSummary.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;
    final packages = (json['packages'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final portfolioItems = (json['portfolioItems'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final startingPrice = packages.isEmpty
        ? 0
        : packages.map((p) => _roundedPrice(p['price'])).reduce((a, b) => a < b ? a : b);
    final rating = (json['rating'] as num?)?.toDouble() ?? 0;
    final isVerified = json['isVerified'] as bool? ?? false;
    return VendorSummary(
      id: json['id'] as String,
      name: (user?['name'] as String?) ?? 'Vendor',
      imageAsset: (json['avatarUrl'] as String?) ??
          (portfolioItems.isNotEmpty ? portfolioItems.first['mediaUrl'] as String? : null) ??
          kFallbackVendorImage,
      city: json['city'] as String? ?? '',
      categoryId: (category?['id'] as String?) ?? json['categoryId'] as String? ?? '',
      rating: rating,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      startingPriceEgp: startingPrice,
      isVerified: isVerified,
      isFeatured: isVerified && rating >= 4.8,
    );
  }
}

/// One page of a paginated vendor search/listing — the app never loads a
/// full vendor list in one shot, per the project brief.
class VendorSearchPage {
  const VendorSearchPage({required this.vendors, required this.hasMore});

  final List<VendorSummary> vendors;
  final bool hasMore;
}

enum SortOption { recommended, highestRated, lowestPrice, highestPrice, featured }

/// Filter/sort criteria applied to a vendor search or listing. Held as
/// one immutable snapshot rather than scattered booleans/strings so the
/// filter bottom sheet, the repository call, and a "filters active"
/// indicator can all read the same shape.
@immutable
class VendorFilters {
  const VendorFilters({
    this.categoryId,
    this.cityId,
    this.minRating,
    this.priceRange = const RangeValues(0, 80000),
    this.sort = SortOption.recommended,
  });

  final String? categoryId;

  /// A [CityModel.id], not its localized display name — vendor city data
  /// is plain, unlocalized text ("Zamalek, Cairo"), so matching against a
  /// translated city name would silently fail whenever the app isn't in
  /// English. The repository owns translating an id to whatever it needs
  /// to match against.
  final String? cityId;
  final double? minRating;
  final RangeValues priceRange;
  final SortOption sort;

  bool get isDefault =>
      categoryId == null &&
      cityId == null &&
      minRating == null &&
      priceRange.start == 0 &&
      priceRange.end == 80000 &&
      sort == SortOption.recommended;
}

/// The API's package shape has no `inclusions` list at all — packages are
/// just `{id, title, description, price}`. Rather than dropping the
/// inclusions list the vendor-side package form already collects, it's
/// packed into the one `description` field the API does store, behind a
/// marker character no vendor would type by hand, and unpacked again on
/// read — so both the vendor's own editor and the customer-facing package
/// card show real inclusions instead of losing them.
const _inclusionsMarker = '|inclusions:';

String encodePackageDescription(String description, List<String> inclusions) {
  if (inclusions.isEmpty) return description;
  return '$description$_inclusionsMarker${inclusions.map(Uri.encodeComponent).join(',')}';
}

class _DecodedPackageDescription {
  const _DecodedPackageDescription({required this.description, required this.inclusions});
  final String description;
  final List<String> inclusions;
}

_DecodedPackageDescription _decodePackageDescription(String raw) {
  final markerIndex = raw.indexOf(_inclusionsMarker);
  if (markerIndex == -1) return _DecodedPackageDescription(description: raw, inclusions: const []);
  final description = raw.substring(0, markerIndex);
  final encoded = raw.substring(markerIndex + _inclusionsMarker.length);
  final inclusions = encoded.isEmpty ? const <String>[] : encoded.split(',').map(Uri.decodeComponent).toList();
  return _DecodedPackageDescription(description: description, inclusions: inclusions);
}

/// One pricing tier a vendor offers. [description] is the one-line summary
/// shown on the Vendor Details preview card; [inclusions] is the fuller
/// bullet breakdown shown on the full Packages screen.
class PackageModel {
  const PackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.priceEgp,
    required this.inclusions,
  });

  final String id;
  final String name;
  final String description;
  final int priceEgp;
  final List<String> inclusions;

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    final decoded = _decodePackageDescription(json['description'] as String? ?? '');
    return PackageModel(
      id: json['id'] as String,
      name: json['title'] as String,
      description: decoded.description,
      priceEgp: _roundedPrice(json['price']),
      inclusions: decoded.inclusions,
    );
  }
}

/// One customer review, shown on the Vendor Details screen. [dateLabel] is
/// pre-formatted by the repository (e.g. "2 weeks ago") so the widget layer
/// never needs its own relative-time logic.
class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.dateLabel,
  });

  final String id;

  /// The reviewing customer's own user id — compared against the signed-in
  /// account to decide whether to show "edit"/"delete" on this review, since
  /// the API only allows a customer to touch their own.
  final String authorId;
  final String authorName;
  final double rating;
  final String comment;
  final String dateLabel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final author = (json['customer'] ?? json['user']) as Map<String, dynamic>?;
    final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '');
    return ReviewModel(
      id: json['id'] as String,
      authorId: (author?['id'] as String?) ?? (json['customerId'] as String?) ?? '',
      authorName: (author?['name'] as String?) ?? 'Anonymous',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] as String? ?? '',
      dateLabel: createdAt != null ? relativeTimeLabel(createdAt) : '',
    );
  }
}

/// One page of a vendor's full review list — reviews are never all loaded
/// at once, same as vendor search/listing.
class VendorReviewsPage {
  const VendorReviewsPage({required this.reviews, required this.hasMore});

  final List<ReviewModel> reviews;
  final bool hasMore;
}

/// How a vendor's reviews split across star ratings, for the bar chart at
/// the top of the full Reviews screen. [counts] has exactly 5 entries,
/// index 0 = 1-star count through index 4 = 5-star count.
class RatingBreakdown {
  const RatingBreakdown({required this.counts});

  final List<int> counts;

  int get total => counts.fold(0, (sum, count) => sum + count);
}

/// Full vendor profile for the Vendor Details screen: everything
/// [VendorSummary] has, plus a photo gallery, an about description, and
/// preview lists of packages/reviews (full package selection and the full
/// review list are their own later phases — this is what the details
/// screen itself needs).
class VendorDetail {
  const VendorDetail({
    required this.id,
    required this.name,
    required this.imageAssets,
    required this.city,
    required this.categoryId,
    required this.rating,
    required this.reviewCount,
    required this.startingPriceEgp,
    required this.description,
    required this.packages,
    required this.reviews,
    this.isVerified = false,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final List<String> imageAssets;
  final String city;
  final String categoryId;
  final double rating;
  final int reviewCount;
  final int startingPriceEgp;
  final String description;
  final List<PackageModel> packages;
  final List<ReviewModel> reviews;
  final bool isVerified;
  final bool isFeatured;

  /// [reviews] isn't part of the vendor detail response itself — the
  /// repository fetches a small first page from `/vendors/:id/reviews`
  /// separately and passes it in here, so this model stays a pure mapping
  /// of "one vendor JSON object" plus whatever preview slice the screen
  /// actually needs.
  factory VendorDetail.fromJson(Map<String, dynamic> json, {List<ReviewModel> reviews = const []}) {
    final user = json['user'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;
    final packagesJson = (json['packages'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final portfolioItems = (json['portfolioItems'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final packages = [for (final p in packagesJson) PackageModel.fromJson(p)];
    final startingPrice = packages.isEmpty ? 0 : packages.map((p) => p.priceEgp).reduce((a, b) => a < b ? a : b);
    final avatarUrl = json['avatarUrl'] as String?;
    final galleryUrls = [for (final item in portfolioItems) item['mediaUrl'] as String];
    final rating = (json['rating'] as num?)?.toDouble() ?? 0;
    final isVerified = json['isVerified'] as bool? ?? false;
    return VendorDetail(
      id: json['id'] as String,
      name: (user?['name'] as String?) ?? 'Vendor',
      imageAssets: [
        ?avatarUrl,
        ...galleryUrls.where((url) => url != avatarUrl),
        if (avatarUrl == null && galleryUrls.isEmpty) kFallbackVendorImage,
      ],
      city: json['city'] as String? ?? '',
      categoryId: (category?['id'] as String?) ?? json['categoryId'] as String? ?? '',
      rating: rating,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      startingPriceEgp: startingPrice,
      description: json['bio'] as String? ?? '',
      packages: packages,
      reviews: reviews,
      isVerified: isVerified,
      isFeatured: isVerified && rating >= 4.8,
    );
  }
}
