/// Which notification categories the customer wants. Purely a stored
/// preference today — there's no push infrastructure yet to actually honor
/// it, but the preference itself is real and will carry straight over once
/// that exists.
class NotificationPreferences {
  const NotificationPreferences({this.bookingUpdates = true, this.promotions = false});

  final bool bookingUpdates;
  final bool promotions;

  NotificationPreferences copyWith({bool? bookingUpdates, bool? promotions}) {
    return NotificationPreferences(
      bookingUpdates: bookingUpdates ?? this.bookingUpdates,
      promotions: promotions ?? this.promotions,
    );
  }
}