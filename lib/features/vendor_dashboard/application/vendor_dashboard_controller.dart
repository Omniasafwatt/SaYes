import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/vendor_dashboard_models.dart';
import '../data/vendor_dashboard_repository.dart';

class VendorDashboardData {
  const VendorDashboardData({required this.stats, required this.recentRequests});

  final VendorDashboardStats stats;
  final List<VendorBookingRequestPreview> recentRequests;
}

/// Loads the vendor Dashboard's overview in parallel. Exposes [refresh] for
/// pull-to-refresh — this screen lives inside a [StatefulShellRoute] branch
/// that's never disposed when switching tabs, so a plain autoDispose
/// provider wouldn't naturally reload on return.
class VendorDashboardController extends AsyncNotifier<VendorDashboardData> {
  @override
  Future<VendorDashboardData> build() => _load();

  Future<VendorDashboardData> _load() async {
    final repository = ref.read(vendorDashboardRepositoryProvider);
    final results = await Future.wait([repository.getStats(), repository.getRecentRequests()]);
    return VendorDashboardData(
      stats: results[0] as VendorDashboardStats,
      recentRequests: results[1] as List<VendorBookingRequestPreview>,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }
}

final vendorDashboardControllerProvider = AsyncNotifierProvider<VendorDashboardController, VendorDashboardData>(
  VendorDashboardController.new,
);
