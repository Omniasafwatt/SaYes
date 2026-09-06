import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/badges.dart';
import 'vendor_booking_request.dart';

/// Contract for the vendor's incoming booking requests.
abstract class VendorBookingsRepository {
  Future<List<VendorBookingRequest>> getRequests();
  Future<void> updateStatus(String id, BookingStatus status);
}

/// TEMPORARY placeholder implementation — same honest pattern as
/// [PlaceholderBookingRepository] on the customer side: no backend exists
/// yet to receive real requests, so this seeds a fixed sample list on first
/// read and persists status changes (accept/decline) on-device via
/// shared_preferences from then on. Replace with a real Dio-backed
/// implementation once the API contract exists; screens and
/// [VendorDashboardController] reading through this interface won't need
/// to change.
class PlaceholderVendorBookingsRepository implements VendorBookingsRepository {
  static const _key = 'sayyes_vendor_booking_requests';

  List<VendorBookingRequest> _seedData() {
    final now = DateTime.now();
    return [
      VendorBookingRequest(
        id: 'r1',
        customerName: 'Nour & Karim',
        packageName: 'Full Day Story',
        packagePriceEgp: 42000,
        eventDate: now.add(const Duration(days: 42)),
        guestCount: 180,
        notes: 'We\'d love an engagement shoot included if possible.',
        status: BookingStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      VendorBookingRequest(
        id: 'r2',
        customerName: 'Mariam & Youssef',
        packageName: 'Essential Coverage',
        packagePriceEgp: 26000,
        eventDate: now.add(const Duration(days: 65)),
        guestCount: 120,
        status: BookingStatus.pending,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      VendorBookingRequest(
        id: 'r3',
        customerName: 'Hana & Omar',
        packageName: 'Cinematic Duo',
        packagePriceEgp: 62000,
        eventDate: now.subtract(const Duration(days: 10)),
        guestCount: 220,
        status: BookingStatus.accepted,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      VendorBookingRequest(
        id: 'r4',
        customerName: 'Salma & Tarek',
        packageName: 'Full Day Story',
        packagePriceEgp: 42000,
        eventDate: now.add(const Duration(days: 90)),
        guestCount: 150,
        notes: 'Venue is outdoors — please bring backup lighting.',
        status: BookingStatus.accepted,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      VendorBookingRequest(
        id: 'r5',
        customerName: 'Yasmin & Ali',
        packageName: 'Essential Coverage',
        packagePriceEgp: 26000,
        eventDate: now.subtract(const Duration(days: 30)),
        guestCount: 90,
        status: BookingStatus.rejected,
        createdAt: now.subtract(const Duration(days: 35)),
      ),
    ];
  }

  Future<void> _save(List<VendorBookingRequest> requests) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, [for (final r in requests) jsonEncode(r.toJson())]);
  }

  @override
  Future<List<VendorBookingRequest>> getRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key);
    if (raw == null) {
      final seeded = _seedData();
      await _save(seeded);
      return seeded;
    }
    return raw.map((entry) => VendorBookingRequest.fromJson(jsonDecode(entry) as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> updateStatus(String id, BookingStatus status) async {
    final requests = await getRequests();
    final updated = [
      for (final r in requests)
        if (r.id == id) r.copyWithStatus(status) else r,
    ];
    await _save(updated);
  }
}

final vendorBookingsRepositoryProvider = Provider<VendorBookingsRepository>(
  (ref) => PlaceholderVendorBookingsRepository(),
);
