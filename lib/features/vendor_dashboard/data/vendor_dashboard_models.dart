import '../../../core/widgets/badges.dart';

/// Top-line numbers for the vendor Dashboard's stat row.
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

/// One row in the Dashboard's "Recent Requests" preview — a couple's
/// booking request as the vendor sees it, not the customer's own
/// [BookingModel] (different account, different side of the same request).
class VendorBookingRequestPreview {
  const VendorBookingRequestPreview({
    required this.id,
    required this.customerName,
    required this.packageName,
    required this.eventDate,
    required this.status,
  });

  final String id;
  final String customerName;
  final String packageName;
  final DateTime eventDate;
  final BookingStatus status;
}
