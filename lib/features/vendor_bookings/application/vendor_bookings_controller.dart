import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/badges.dart';
import '../data/vendor_booking_request.dart';
import '../data/vendor_bookings_repository.dart';

/// The vendor's incoming booking requests, most-recently-submitted first.
/// Exposes [accept]/[decline] as imperative methods rather than relying on
/// re-watching — this screen lives inside a [StatefulShellRoute] branch
/// that's never disposed when switching tabs.
class VendorBookingsController extends AsyncNotifier<List<VendorBookingRequest>> {
  @override
  Future<List<VendorBookingRequest>> build() => _load();

  Future<List<VendorBookingRequest>> _load() async {
    final requests = await ref.read(vendorBookingsRepositoryProvider).getRequests();
    return requests.reversed.toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> _updateStatus(String id, BookingStatus status) async {
    await ref.read(vendorBookingsRepositoryProvider).updateStatus(id, status);
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data([
      for (final r in current)
        if (r.id == id) r.copyWithStatus(status) else r,
    ]);
  }

  Future<void> accept(String id) => _updateStatus(id, BookingStatus.accepted);

  Future<void> decline(String id) => _updateStatus(id, BookingStatus.rejected);
}

final vendorBookingsControllerProvider = AsyncNotifierProvider<VendorBookingsController, List<VendorBookingRequest>>(
  VendorBookingsController.new,
);
