import '../../../core/widgets/badges.dart';

/// One submitted booking request. [eventDate] is stored as a plain DateTime
/// (date only — time-of-day isn't collected yet); the vendor's own
/// name/image are copied in at submission time rather than re-fetched, so
/// this record stays readable even if that vendor is later removed.
class BookingModel {
  const BookingModel({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.vendorImageAsset,
    required this.packageName,
    required this.packagePriceEgp,
    required this.eventDate,
    required this.guestCount,
    required this.notes,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String vendorId;
  final String vendorName;
  final String vendorImageAsset;
  final String packageName;
  final int packagePriceEgp;
  final DateTime eventDate;
  final int guestCount;
  final String? notes;
  final BookingStatus status;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'vendorId': vendorId,
        'vendorName': vendorName,
        'vendorImageAsset': vendorImageAsset,
        'packageName': packageName,
        'packagePriceEgp': packagePriceEgp,
        'eventDate': eventDate.toIso8601String(),
        'guestCount': guestCount,
        'notes': notes,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json['id'] as String,
        vendorId: json['vendorId'] as String,
        vendorName: json['vendorName'] as String,
        vendorImageAsset: json['vendorImageAsset'] as String,
        packageName: json['packageName'] as String,
        packagePriceEgp: json['packagePriceEgp'] as int,
        eventDate: DateTime.parse(json['eventDate'] as String),
        guestCount: json['guestCount'] as int,
        notes: json['notes'] as String?,
        status: BookingStatus.values.byName(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
