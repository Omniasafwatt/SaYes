/// Top-line numbers for the vendor Dashboard's stat row. [newRequestCount]
/// and [monthBookingCount] are derived from the vendor's real booking
/// requests (see [VendorDashboardController]); [rating]/[reviewCount] are
/// a separate vendor-level metric a backend would own directly, sourced
/// from [VendorDashboardRepository].
class VendorDashboardStats {
  const VendorDashboardStats({
    required this.newRequestCount,
    required this.monthBookingCount,
    required this.rating,
    required this.reviewCount,
  });

  final int newRequestCount;
  final int monthBookingCount;
  final double rating;
  final int reviewCount;
}
