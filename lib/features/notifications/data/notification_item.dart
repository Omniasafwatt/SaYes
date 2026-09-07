/// What a notification is about — drives which icon it shows. Mirrors the
/// two categories a user can toggle on the Profile screen's notification
/// switches, so "turn off promotions" and "what kind of thing is this"
/// share one vocabulary.
enum NotificationCategory { bookingUpdate, promotion }

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
  });

  final String id;
  final NotificationCategory category;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  NotificationItem copyWithRead(bool value) => NotificationItem(
        id: id,
        category: category,
        title: title,
        body: body,
        createdAt: createdAt,
        read: value,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category.name,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'read': read,
      };

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
        id: json['id'] as String,
        category: NotificationCategory.values.byName(json['category'] as String),
        title: json['title'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        read: json['read'] as bool,
      );
}
