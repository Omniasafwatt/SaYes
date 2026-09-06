import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/badges.dart';
import '../../vendor_bookings/application/vendor_bookings_controller.dart';
import '../../vendor_bookings/data/vendor_booking_request.dart';
import '../data/vendor_dashboard_models.dart';
import '../data/vendor_dashboard_repository.dart';

class VendorDashboardData {
  const VendorDashboardData({required this.stats, required this.recentRequests});

  final VendorDashboardStats stats;
  final List<VendorBookingRequest> recentRequests;
}

/// Loads the vendor Dashboard's overview. [newRequestCount] and
/// [monthBookingCount] are computed from the same booking-request data the
/// Bookings tab manages — watched via [vendorBookingsControllerProvider]
/// rather than read from the repository directly, so accepting/declining a
/// request there rebuilds this provider automatically, with no manual
/// refresh call needed to keep the two tabs in sync. Exposes [refresh]
/// anyway for pull-to-refresh, which also re-syncs the rating summary.
class VendorDashboardController extends AsyncNotifier<VendorDashboardData> {
  @override
  Future<VendorDashboardData> build() async {
    final ratingSummary = await ref.read(vendorDashboardRepositoryProvider).getRatingSummary();
    final requests = await ref.watch(vendorBookingsControllerProvider.future);

    final sorted = [...requests]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final stats = VendorDashboardStats(
      newRequestCount: requests.where((r) => r.status == BookingStatus.pending).length,
      // "This month" isn't date-filtered against a real calendar month yet
      // (the placeholder dataset is too small for that to mean anything) —
      // it's every request this vendor has accepted so far.
      monthBookingCount: requests.where((r) => r.status == BookingStatus.accepted).length,
      rating: ratingSummary.rating,
      reviewCount: ratingSummary.reviewCount,
    );

    return VendorDashboardData(stats: stats, recentRequests: sorted.take(3).toList());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    ref.invalidate(vendorBookingsControllerProvider);
    state = await AsyncValue.guard(build);
  }
}

final vendorDashboardControllerProvider = AsyncNotifierProvider<VendorDashboardController, VendorDashboardData>(
  VendorDashboardController.new,
);
