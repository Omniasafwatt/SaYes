import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/pagination.dart';
import '../../../core/widgets/badges.dart';
import 'vendor_booking_request.dart';

/// Contract for the vendor's incoming booking requests.
abstract class VendorBookingsRepository {
  Future<List<VendorBookingRequest>> getRequests();
  Future<void> updateStatus(String id, BookingStatus status);
}

/// Real implementation, backed by `GET /bookings/incoming` and
/// `PATCH /bookings/:id/accept|reject`.
class ApiVendorBookingsRepository implements VendorBookingsRepository {
  ApiVendorBookingsRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<VendorBookingRequest>> getRequests() async {
    final data = await _api.get('/bookings/incoming');
    final parsed = parsePage(data, requestedPage: 1);
    return [for (final item in parsed.items) VendorBookingRequest.fromApiJson(item as Map<String, dynamic>)];
  }

  @override
  Future<void> updateStatus(String id, BookingStatus status) async {
    final action = status == BookingStatus.accepted ? 'accept' : 'reject';
    await _api.patch('/bookings/$id/$action');
  }
}

final vendorBookingsRepositoryProvider = Provider<VendorBookingsRepository>(
  (ref) => ApiVendorBookingsRepository(ref.watch(apiClientProvider)),
);
