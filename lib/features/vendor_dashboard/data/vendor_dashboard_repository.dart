import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

/// Contract for the vendor-level metrics the Dashboard shows that aren't
/// derived from booking requests — today, just the aggregate rating.
abstract class VendorDashboardRepository {
  Future<({double rating, int reviewCount})> getRatingSummary();
}

/// Real implementation — `GET /vendors/me` already carries the vendor's own
/// aggregate `rating`/`reviewCount`, the same fields [VendorSummary.fromJson]
/// reads for the customer-facing card.
class ApiVendorDashboardRepository implements VendorDashboardRepository {
  ApiVendorDashboardRepository(this._api);

  final ApiClient _api;

  @override
  Future<({double rating, int reviewCount})> getRatingSummary() async {
    final data = await _api.get('/vendors/me') as Map<String, dynamic>;
    return (
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
    );
  }
}

final vendorDashboardRepositoryProvider = Provider<VendorDashboardRepository>(
  (ref) => ApiVendorDashboardRepository(ref.watch(apiClientProvider)),
);
