import 'package:flutter/material.dart';

/// Vendor card data for listing surfaces (Home carousels, Search results,
/// and later the full Vendor Listing screen in Phase 9). A fuller vendor
/// detail model arrives with Phase 10; this is intentionally the slice a
/// listing card needs.
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
