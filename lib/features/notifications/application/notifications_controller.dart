import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_models.dart';
import '../../profile/application/user_profile_controller.dart';
import '../data/notification_item.dart';
import '../data/notifications_repository.dart';

/// The signed-in account's notifications, most-recent-first. Exposes
/// [markAsRead]/[markAllAsRead] as imperative methods rather than relying
/// on re-watching — the bell that opens this screen lives on the Home/
/// Dashboard tab of a [StatefulShellRoute] branch that's never disposed
/// when navigating away, so its unread-count badge needs this provider's
/// state to update in place.
class NotificationsController extends AsyncNotifier<List<NotificationItem>> {
  @override
  Future<List<NotificationItem>> build() => _load();

  Future<UserRole> _currentRole() async {
    final profile = await ref.watch(userProfileControllerProvider.future);
    return profile?.role ?? UserRole.customer;
  }

  Future<List<NotificationItem>> _load() async {
    final role = await _currentRole();
    final items = await ref.read(notificationsRepositoryProvider).getNotifications(role);
    return [...items]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> markAsRead(String id) async {
    final role = await _currentRole();
    await ref.read(notificationsRepositoryProvider).markAsRead(role, id);
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data([
      for (final n in current)
        if (n.id == id) n.copyWithRead(true) else n,
    ]);
  }

  Future<void> markAllAsRead() async {
    final role = await _currentRole();
    await ref.read(notificationsRepositoryProvider).markAllAsRead(role);
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data([for (final n in current) n.copyWithRead(true)]);
  }
}

final notificationsControllerProvider = AsyncNotifierProvider<NotificationsController, List<NotificationItem>>(
  NotificationsController.new,
);
