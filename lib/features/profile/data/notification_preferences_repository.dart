import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_preferences.dart';

abstract class NotificationPreferencesRepository {
  Future<NotificationPreferences> getPreferences();
  Future<void> savePreferences(NotificationPreferences preferences);
}

/// Local-only — see [NotificationPreferences] for why that's honest rather
/// than a gap.
class LocalNotificationPreferencesRepository implements NotificationPreferencesRepository {
  static const _bookingUpdatesKey = 'sayyes_notif_booking_updates';

  @override
  Future<NotificationPreferences> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationPreferences(bookingUpdates: prefs.getBool(_bookingUpdatesKey) ?? true);
  }

  @override
  Future<void> savePreferences(NotificationPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_bookingUpdatesKey, preferences.bookingUpdates);
  }
}

final notificationPreferencesRepositoryProvider = Provider<NotificationPreferencesRepository>(
  (ref) => LocalNotificationPreferencesRepository(),
);
