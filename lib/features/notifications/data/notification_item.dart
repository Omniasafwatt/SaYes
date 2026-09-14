/// What actually happened to a booking — drives both the notification's
/// icon/accent color and, since it's folded into [NotificationItem.id],
/// whether a status change re-surfaces as unread. There's no real
/// notification log in the API (no timestamped "this event happened"
/// record) — only current-state bookings — so a booking that flips from
/// pending to accepted becomes a *new* notification id rather than an
/// update to the old one, which is what makes "new status → unread again"
/// work without any extra server-side support.
enum NotificationKind { requestSent, requestAccepted, requestRejected, incomingRequest }

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
  });

  final String id;
  final NotificationKind kind;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  NotificationItem copyWithRead(bool value) => NotificationItem(
        id: id,
        kind: kind,
        title: title,
        body: body,
        createdAt: createdAt,
        read: value,
      );
}
