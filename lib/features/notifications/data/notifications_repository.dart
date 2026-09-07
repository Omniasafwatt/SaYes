import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/data/auth_models.dart';
import 'notification_item.dart';

/// Contract for a signed-in account's notification inbox. Every method
/// takes the account's [UserRole] since a real backend would send a
/// customer booking-status updates about vendors they booked and a vendor
/// new-request alerts about couples booking them — different content, same
/// inbox shape, and this placeholder needs the role to know which sample
/// set it's reading/writing (see [PlaceholderNotificationsRepository]).
abstract class NotificationsRepository {
  Future<List<NotificationItem>> getNotifications(UserRole role);
  Future<void> markAsRead(UserRole role, String id);
  Future<void> markAllAsRead(UserRole role);
}

/// TEMPORARY placeholder implementation — same honest pattern as
/// [PlaceholderVendorBookingsRepository]: no backend exists yet to push
/// real notifications, so this seeds a fixed, role-appropriate sample list
/// on first read and persists read/unread state on-device via
/// shared_preferences from then on. Storage is keyed by role (not by
/// account) — this device gets one "customer" sample inbox and one
/// "vendor" one. That's coarser than real per-account data, but without it
/// a customer account and a vendor account sharing this device would
/// share one seeded-once inbox, so a fresh vendor signup could inherit a
/// customer's leftover "your booking was accepted" notification — content
/// that reads as genuinely broken for that role, not just generic
/// placeholder data. Replace with a real Dio-backed/push-driven
/// implementation once the API contract exists; screens reading through
/// [NotificationsRepository] won't need to change.
class PlaceholderNotificationsRepository implements NotificationsRepository {
  String _keyFor(UserRole role) => 'sayyes_notifications_${role.name}';

  List<NotificationItem> _seedFor(UserRole role) {
    final now = DateTime.now();
    if (role == UserRole.vendor) {
      return [
        NotificationItem(
          id: 'n1',
          category: NotificationCategory.bookingUpdate,
          title: 'New booking request',
          body: 'Mariam & Youssef requested Essential Coverage for November 10, 2026.',
          createdAt: now.subtract(const Duration(hours: 3)),
          read: false,
        ),
        NotificationItem(
          id: 'n2',
          category: NotificationCategory.bookingUpdate,
          title: 'Upcoming event reminder',
          body: 'Your event with Hana & Omar is in two weeks — August 27, 2026.',
          createdAt: now.subtract(const Duration(days: 1)),
          read: false,
        ),
        NotificationItem(
          id: 'n3',
          category: NotificationCategory.promotion,
          title: 'Grow your business',
          body: 'Vendors with a complete portfolio get up to 3x more booking requests.',
          createdAt: now.subtract(const Duration(days: 4)),
          read: true,
        ),
      ];
    }
    return [
      NotificationItem(
        id: 'n1',
        category: NotificationCategory.bookingUpdate,
        title: 'Booking request accepted',
        body: 'Nour Al Sham Wedding Hall accepted your request for December 5, 2026.',
        createdAt: now.subtract(const Duration(hours: 5)),
        read: false,
      ),
      NotificationItem(
        id: 'n2',
        category: NotificationCategory.bookingUpdate,
        title: 'Booking request sent',
        body: "Your request to Amira Lens Photography is on its way — we'll notify you when they respond.",
        createdAt: now.subtract(const Duration(days: 2)),
        read: true,
      ),
      NotificationItem(
        id: 'n3',
        category: NotificationCategory.promotion,
        title: 'Special offer this week',
        body: '20% off bridal styling sessions booked before the end of the month.',
        createdAt: now.subtract(const Duration(days: 3)),
        read: false,
      ),
    ];
  }

  Future<void> _save(UserRole role, List<NotificationItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFor(role), [for (final n in items) jsonEncode(n.toJson())]);
  }

  @override
  Future<List<NotificationItem>> getNotifications(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyFor(role));
    if (raw == null) {
      final seeded = _seedFor(role);
      await _save(role, seeded);
      return seeded;
    }
    return raw.map((entry) => NotificationItem.fromJson(jsonDecode(entry) as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> markAsRead(UserRole role, String id) async {
    final items = await getNotifications(role);
    await _save(role, [
      for (final n in items)
        if (n.id == id) n.copyWithRead(true) else n,
    ]);
  }

  @override
  Future<void> markAllAsRead(UserRole role) async {
    final items = await getNotifications(role);
    await _save(role, [for (final n in items) n.copyWithRead(true)]);
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) => PlaceholderNotificationsRepository());
