import '../../../core/widgets/badges.dart';

/// A couple's booking request as the vendor sees it — the other side of a
/// customer's own [BookingModel]. A real backend would link the two by a
/// shared booking id; this placeholder has no such link since customer and
/// vendor accounts here don't share any actual backend record.
class VendorBookingRequest {
  const VendorBookingRequest({
    required this.id,
    required this.customerName,
    required this.packageName,
    required this.packagePriceEgp,
    required this.eventDate,
    required this.guestCount,
    this.notes,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String customerName;
  final String packageName;
  final int packagePriceEgp;
  final DateTime eventDate;
  final int guestCount;
  final String? notes;
  final BookingStatus status;
  final DateTime createdAt;

  VendorBookingRequest copyWithStatus(BookingStatus newStatus) => VendorBookingRequest(
        id: id,
        customerName: customerName,
        packageName: packageName,
        packagePriceEgp: packagePriceEgp,
        eventDate: eventDate,
        guestCount: guestCount,
        notes: notes,
        status: newStatus,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'packageName': packageName,
        'packagePriceEgp': packagePriceEgp,
        'eventDate': eventDate.toIso8601String(),
        'guestCount': guestCount,
        'notes': notes,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory VendorBookingRequest.fromJson(Map<String, dynamic> json) => VendorBookingRequest(
        id: json['id'] as String,
        customerName: json['customerName'] as String,
        packageName: json['packageName'] as String,
        packagePriceEgp: json['packagePriceEgp'] as int,
        eventDate: DateTime.parse(json['eventDate'] as String),
        guestCount: json['guestCount'] as int,
        notes: json['notes'] as String?,
        status: BookingStatus.values.byName(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
