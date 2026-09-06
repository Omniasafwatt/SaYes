import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_preferences.dart';

abstract class NotificationPreferencesRepository {
  Future<NotificationPreferences> getPreferences();
  Future<void> savePreferences(NotificationPreferences preferences);
}

/// Local-only for now — see [NotificationPreferences] for why that's
/// honest rather than a gap: there's nothing server-side to sync with yet.
class PlaceholderNotificationPreferencesRepository implements NotificationPreferencesRepository {
  static const _bookingUpdatesKey = 'sayyes_notif_booking_updates';
  static const _promotionsKey = 'sayyes_notif_promotions';

  @override
  Future<NotificationPreferences> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationPreferences(
      bookingUpdates: prefs.getBool(_bookingUpdatesKey) ?? true,
      promotions: prefs.getBool(_promotionsKey) ?? false,
    );
  }

  @override
  Future<void> savePreferences(NotificationPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_bookingUpdatesKey, preferences.bookingUpdates);
    await prefs.setBool(_promotionsKey, preferences.promotions);
  }
}

final notificationPreferencesRepositoryProvider = Provider<NotificationPreferencesRepository>(
  (ref) => PlaceholderNotificationPreferencesRepository(),
);
