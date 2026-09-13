import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/pagination.dart';
import 'booking_message_codec.dart';
import 'booking_models.dart';

/// Contract for submitting and reading back a customer's booking requests.
abstract class BookingRepository {
  Future<List<BookingModel>> getBookings();

  Future<BookingModel> submitBookingRequest({
    required String vendorId,
    required String vendorName,
    required String vendorImageAsset,
    required String packageName,
    required int packagePriceEgp,
    required DateTime eventDate,
    required int guestCount,
    String? notes,
  });
}

/// Real implementation, backed by `POST /bookings` + `GET /bookings/mine`.
/// The create endpoint only accepts `{vendorId, eventDate, message}` — see
/// `booking_message_codec.dart` for how package/guest-count still ride
/// along despite that.
class ApiBookingRepository implements BookingRepository {
  ApiBookingRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<BookingModel>> getBookings() async {
    final data = await _api.get('/bookings/mine');
    final parsed = parsePage(data, requestedPage: 1);
    return [
      for (final item in parsed.items)
        BookingModel.fromApiJson(
          item as Map<String, dynamic>,
          fallbackVendorName: 'Vendor',
          fallbackPackageName: 'Booking request',
        ),
    ];
  }

  @override
  Future<BookingModel> submitBookingRequest({
    required String vendorId,
    required String vendorName,
    required String vendorImageAsset,
    required String packageName,
    required int packagePriceEgp,
    required DateTime eventDate,
    required int guestCount,
    String? notes,
  }) async {
    final message = encodeBookingMessage(
      vendorName: vendorName,
      packageName: packageName,
      packagePriceEgp: packagePriceEgp,
      guestCount: guestCount,
      notes: notes,
    );
    final data = await _api.post('/bookings', data: {
      'vendorId': vendorId,
      'eventDate': eventDate.toIso8601String().split('T').first,
      'message': message,
    }) as Map<String, dynamic>;

    return BookingModel(
      id: data['id'] as String,
      vendorId: vendorId,
      vendorName: vendorName,
      vendorImageAsset: vendorImageAsset,
      packageName: packageName,
      packagePriceEgp: packagePriceEgp,
      eventDate: eventDate,
      guestCount: guestCount,
      notes: notes,
      status: bookingStatusFromApi(data['status'] as String?),
      createdAt: DateTime.tryParse(data['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) => ApiBookingRepository(ref.watch(apiClientProvider)));
