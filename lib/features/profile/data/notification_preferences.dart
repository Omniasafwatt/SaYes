/// Whether the account wants booking-update notifications at all. Purely a
/// stored preference today — there's no push infrastructure yet to
/// actually deliver anything while the app isn't open, but the in-app
/// notification inbox itself does honor it (off means it renders empty).
class NotificationPreferences {
  const NotificationPreferences({this.bookingUpdates = true});

  final bool bookingUpdates;

  NotificationPreferences copyWith({bool? bookingUpdates}) {
    return NotificationPreferences(bookingUpdates: bookingUpdates ?? this.bookingUpdates);
  }
}
