import '../../vendors/data/vendor_models.dart';

/// One uploaded portfolio photo/video as the vendor sees it while managing
/// their own listing. Unlike the customer-facing gallery (a flat list of
/// URLs), the vendor's own view needs each item's id too — deleting a
/// portfolio item is `DELETE /portfolio/:id`, not by URL.
class PortfolioItemRef {
  const PortfolioItemRef({required this.id, required this.mediaUrl});

  final String id;
  final String mediaUrl;

  factory PortfolioItemRef.fromJson(Map<String, dynamic> json) =>
      PortfolioItemRef(id: json['id'] as String, mediaUrl: json['mediaUrl'] as String);
}

/// A vendor's own editable listing — what customers see as [VendorDetail]
/// on the other side. Kept as its own model (rather than reusing
/// [VendorDetail] directly) since a vendor editing their listing needs a
/// flat, mutable shape with no reviews/rating fields — those are earned,
/// not self-reported.
class VendorListingProfile {
  const VendorListingProfile({
    required this.vendorId,
    required this.businessName,
    required this.categoryId,
    required this.city,
    required this.startingPriceEgp,
    required this.description,
    required this.portfolio,
    required this.packages,
  });

  /// The vendor record's own id — needed by every mutation endpoint
  /// (`/vendors/:id`, `/vendors/:id/packages`, `/vendors/:id/portfolio`),
  /// which is why it's carried on the profile rather than looked up again
  /// on every call.
  final String vendorId;
  final String businessName;
  final String categoryId;
  final String city;
  final int startingPriceEgp;
  final String description;
  final List<PortfolioItemRef> portfolio;
  final List<PackageModel> packages;
}
