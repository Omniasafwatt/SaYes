import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/badges.dart';
import 'vendor_dashboard_models.dart';

/// Contract for the vendor Dashboard's overview data. A real backend would
/// scope every value to the signed-in vendor's own account.
abstract class VendorDashboardRepository {
  Future<VendorDashboardStats> getStats();
  Future<List<VendorBookingRequestPreview>> getRecentRequests();
}

/// TEMPORARY placeholder implementation — same honest pattern as
/// [PlaceholderHomeRepository]: no backend yet, so this returns a fixed,
/// clearly-a-demo dataset rather than pretending to read a real vendor's
/// actual bookings (there's no notion yet of "which vendor is this account"
/// — that link only makes sense once a backend assigns an account a real
/// business listing). Replace with a real Dio-backed implementation once
/// the API contract exists; nothing above this class should need to change.
class PlaceholderVendorDashboardRepository implements VendorDashboardRepository {
  Future<void> _simulateLatency() => Future.delayed(const Duration(milliseconds: 600));

  @override
  Future<VendorDashboardStats> getStats() async {
    await _simulateLatency();
    return const VendorDashboardStats(newRequestCount: 3, monthBookingCount: 7, rating: 4.8, reviewCount: 32);
  }

  @override
  Future<List<VendorBookingRequestPreview>> getRecentRequests() async {
    await _simulateLatency();
    final now = DateTime.now();
    return [
      VendorBookingRequestPreview(
        id: 'r1',
        customerName: 'Nour & Karim',
        packageName: 'Full Day Story',
        eventDate: now.add(const Duration(days: 42)),
        status: BookingStatus.pending,
      ),
      VendorBookingRequestPreview(
        id: 'r2',
        customerName: 'Mariam & Youssef',
        packageName: 'Essential Coverage',
        eventDate: now.add(const Duration(days: 65)),
        status: BookingStatus.pending,
      ),
      VendorBookingRequestPreview(
        id: 'r3',
        customerName: 'Hana & Omar',
        packageName: 'Cinematic Duo',
        eventDate: now.subtract(const Duration(days: 10)),
        status: BookingStatus.accepted,
      ),
    ];
  }
}

final vendorDashboardRepositoryProvider = Provider<VendorDashboardRepository>(
  (ref) => PlaceholderVendorDashboardRepository(),
);
