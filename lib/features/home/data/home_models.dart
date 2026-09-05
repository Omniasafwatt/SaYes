import 'package:flutter/widgets.dart';

/// A service category as the backend would return it — id + display name +
/// an icon. Real categories are entirely admin-managed; the app never
/// hard-codes which categories exist (per the project brief), only how to
/// render one once it arrives. [icon] is a presentation fallback for
/// categories that don't ship an image from the backend.
class CategoryModel {
  const CategoryModel({required this.id, required this.name, required this.icon});

  final String id;
  final String name;
  final IconData icon;
}

/// Vendor card data for home-feed carousels (featured/popular). A fuller
/// vendor detail model arrives with Phase 9/10; this is intentionally the
/// slice a listing card needs.
class VendorSummary {
  const VendorSummary({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.city,
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
  final double rating;
  final int reviewCount;
  final int startingPriceEgp;
  final bool isVerified;
  final bool isFeatured;
}

class CityModel {
  const CityModel({required this.id, required this.name, required this.vendorCount});

  final String id;
  final String name;
  final int vendorCount;
}
