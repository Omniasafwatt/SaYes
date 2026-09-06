import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/badges.dart';
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

/// TEMPORARY placeholder implementation — same honest pattern as the other
/// Placeholder repositories: no backend exists yet to receive a real
/// booking request or notify the vendor, so this only persists on-device
/// via shared_preferences and always resolves as "pending". Replace with a
/// real Dio-backed implementation once the API contract exists; screens
/// reading through [BookingRepository] won't need to change.
class PlaceholderBookingRepository implements BookingRepository {
  static const _key = 'sayyes_bookings';

  @override
  Future<List<BookingModel>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    return raw.map((entry) => BookingModel.fromJson(jsonDecode(entry) as Map<String, dynamic>)).toList();
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
    await Future.delayed(const Duration(milliseconds: 900));

    final booking = BookingModel(
      id: 'booking-${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 32)}',
      vendorId: vendorId,
      vendorName: vendorName,
      vendorImageAsset: vendorImageAsset,
      packageName: packageName,
      packagePriceEgp: packagePriceEgp,
      eventDate: eventDate,
      guestCount: guestCount,
      notes: notes,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );

    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? const [];
    await prefs.setStringList(_key, [...current, jsonEncode(booking.toJson())]);

    return booking;
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) => PlaceholderBookingRepository());
