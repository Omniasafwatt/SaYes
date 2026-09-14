import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/badges.dart';
import '../../auth/data/auth_models.dart';
import '../../bookings/data/booking_repository.dart';
import '../../vendor_bookings/data/vendor_bookings_repository.dart';
import 'notification_item.dart';

/// Contract for a signed-in account's notification inbox.
abstract class NotificationsRepository {
  Future<List<NotificationItem>> getNotifications(UserRole role, AppLocalizations l10n);
  Future<void> markAsRead(UserRole role, String id);
  Future<void> markAllAsRead(UserRole role, AppLocalizations l10n);
}

/// There's no notifications endpoint in the API at all — no push
/// infrastructure, no event log. Rather than showing invented content with
/// invented names, this derives a real inbox from data the account
/// genuinely has: a customer's own bookings (`/bookings/mine`) and a
/// vendor's own incoming requests (`/bookings/incoming`), turned into one
/// notification per booking reflecting its actual current status. "Read"
/// has nothing server-side to live on, so it's tracked locally by id — see
/// [NotificationKind]'s doc comment for why a status change still surfaces
/// as unread despite that.
class ApiNotificationsRepository implements NotificationsRepository {
  ApiNotificationsRepository(this._bookingRepository, this._vendorBookingsRepository);

  final BookingRepository _bookingRepository;
  final VendorBookingsRepository _vendorBookingsRepository;

  String _readKey(UserRole role) => 'sayyes_notifications_read_${role.name}';

  Future<Set<String>> _readIds(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_readKey(role)) ?? const []).toSet();
  }

  Future<void> _saveReadIds(UserRole role, Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_readKey(role), ids.toList());
  }

  Future<List<NotificationItem>> _customerNotifications(AppLocalizations l10n, Set<String> readIds) async {
    final dateFormat = DateFormat.yMMMd(l10n.localeName);
    final bookings = await _bookingRepository.getBookings();
    return [
      for (final booking in bookings)
        switch (booking.status) {
          BookingStatus.pending => NotificationItem(
              id: '${booking.id}_pending',
              kind: NotificationKind.requestSent,
              title: l10n.notificationSentTitle,
              body: l10n.notificationSentBody(booking.vendorName),
              createdAt: booking.createdAt,
              read: readIds.contains('${booking.id}_pending'),
            ),
          BookingStatus.accepted => NotificationItem(
              id: '${booking.id}_accepted',
              kind: NotificationKind.requestAccepted,
              title: l10n.notificationAcceptedTitle,
              body: l10n.notificationAcceptedBody(booking.vendorName, dateFormat.format(booking.eventDate)),
              createdAt: booking.createdAt,
              read: readIds.contains('${booking.id}_accepted'),
            ),
          BookingStatus.rejected => NotificationItem(
              id: '${booking.id}_rejected',
              kind: NotificationKind.requestRejected,
              title: l10n.notificationRejectedTitle,
              body: l10n.notificationRejectedBody(booking.vendorName),
              createdAt: booking.createdAt,
              read: readIds.contains('${booking.id}_rejected'),
            ),
        },
    ];
  }

  Future<List<NotificationItem>> _vendorNotifications(AppLocalizations l10n, Set<String> readIds) async {
    final dateFormat = DateFormat.yMMMd(l10n.localeName);
    final requests = await _vendorBookingsRepository.getRequests();
    return [
      for (final request in requests)
        switch (request.status) {
          BookingStatus.pending => NotificationItem(
              id: '${request.id}_pending',
              kind: NotificationKind.incomingRequest,
              title: l10n.notificationIncomingTitle,
              body: l10n.notificationIncomingBody(request.customerName, request.packageName, dateFormat.format(request.eventDate)),
              createdAt: request.createdAt,
              read: readIds.contains('${request.id}_pending'),
            ),
          BookingStatus.accepted => NotificationItem(
              id: '${request.id}_accepted',
              kind: NotificationKind.requestAccepted,
              title: l10n.notificationVendorAcceptedTitle,
              body: l10n.notificationVendorAcceptedBody(request.customerName, dateFormat.format(request.eventDate)),
              createdAt: request.createdAt,
              read: readIds.contains('${request.id}_accepted'),
            ),
          BookingStatus.rejected => NotificationItem(
              id: '${request.id}_rejected',
              kind: NotificationKind.requestRejected,
              title: l10n.notificationVendorRejectedTitle,
              body: l10n.notificationVendorRejectedBody(request.customerName),
              createdAt: request.createdAt,
              read: readIds.contains('${request.id}_rejected'),
            ),
        },
    ];
  }

  @override
  Future<List<NotificationItem>> getNotifications(UserRole role, AppLocalizations l10n) async {
    final readIds = await _readIds(role);
    return role == UserRole.vendor ? _vendorNotifications(l10n, readIds) : _customerNotifications(l10n, readIds);
  }

  @override
  Future<void> markAsRead(UserRole role, String id) async {
    final ids = await _readIds(role);
    ids.add(id);
    await _saveReadIds(role, ids);
  }

  @override
  Future<void> markAllAsRead(UserRole role, AppLocalizations l10n) async {
    final items = await getNotifications(role, l10n);
    await _saveReadIds(role, {for (final n in items) n.id});
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => ApiNotificationsRepository(ref.watch(bookingRepositoryProvider), ref.watch(vendorBookingsRepositoryProvider)),
);
