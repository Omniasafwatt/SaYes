import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/booking_models.dart';
import '../data/booking_repository.dart';

/// The customer's submitted booking requests, most-recent-first. A plain
/// FutureProvider wouldn't pick up a booking submitted after this provider
/// was first read (the Bookings tab stays mounted in the shell's
/// IndexedStack, so nothing would ever re-watch it) — this Notifier's
/// [refresh] is called right after a successful submission instead.
class BookingsController extends AsyncNotifier<List<BookingModel>> {
  @override
  Future<List<BookingModel>> build() => _load();

  Future<List<BookingModel>> _load() async {
    final bookings = await ref.read(bookingRepositoryProvider).getBookings();
    return bookings.reversed.toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }
}

final bookingsControllerProvider = AsyncNotifierProvider<BookingsController, List<BookingModel>>(
  BookingsController.new,
);
