import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notification_preferences.dart';
import '../data/notification_preferences_repository.dart';

class NotificationPreferencesController extends Notifier<NotificationPreferences> {
  @override
  NotificationPreferences build() {
    _restorePersisted();
    return const NotificationPreferences();
  }

  Future<void> _restorePersisted() async {
    state = await ref.read(notificationPreferencesRepositoryProvider).getPreferences();
  }

  void setBookingUpdates(bool value) => _update(state.copyWith(bookingUpdates: value));

  void setPromotions(bool value) => _update(state.copyWith(promotions: value));

  void _update(NotificationPreferences next) {
    state = next;
    ref.read(notificationPreferencesRepositoryProvider).savePreferences(next);
  }
}

final notificationPreferencesControllerProvider =
    NotifierProvider<NotificationPreferencesController, NotificationPreferences>(
  NotificationPreferencesController.new,
);
