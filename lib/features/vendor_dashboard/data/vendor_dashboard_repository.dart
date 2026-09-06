import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contract for the vendor-level metrics the Dashboard shows that aren't
/// derived from booking requests — today, just the aggregate rating.
abstract class VendorDashboardRepository {
  Future<({double rating, int reviewCount})> getRatingSummary();
}

/// TEMPORARY placeholder implementation — same honest pattern as
/// [PlaceholderHomeRepository]: no backend yet, so this returns a fixed,
/// clearly-a-demo rating. Replace with a real Dio-backed implementation
/// once the API contract exists; nothing above this class should need to
/// change.
class PlaceholderVendorDashboardRepository implements VendorDashboardRepository {
  @override
  Future<({double rating, int reviewCount})> getRatingSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return (rating: 4.8, reviewCount: 32);
  }
}

final vendorDashboardRepositoryProvider = Provider<VendorDashboardRepository>(
  (ref) => PlaceholderVendorDashboardRepository(),
);
