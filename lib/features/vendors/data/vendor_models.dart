import 'package:flutter/material.dart';

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
    this.city,
    this.minRating,
    this.priceRange = const RangeValues(0, 80000),
    this.sort = SortOption.recommended,
  });

  final String? categoryId;
  final String? city;
  final double? minRating;
  final RangeValues priceRange;
  final SortOption sort;

  bool get isDefault =>
      categoryId == null &&
      city == null &&
      minRating == null &&
      priceRange.start == 0 &&
      priceRange.end == 80000 &&
      sort == SortOption.recommended;
}

/// One pricing tier a vendor offers, shown on the Vendor Details screen.
class PackageModel {
  const PackageModel({required this.id, required this.name, required this.description, required this.priceEgp});

  final String id;
  final String name;
  final String description;
  final int priceEgp;
}

/// One customer review, shown on the Vendor Details screen. [dateLabel] is
/// pre-formatted by the repository (e.g. "2 weeks ago") so the widget layer
/// never needs its own relative-time logic.
class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.dateLabel,
  });

  final String id;
  final String authorName;
  final double rating;
  final String comment;
  final String dateLabel;
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
}
