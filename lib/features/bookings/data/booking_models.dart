import '../../../core/widgets/badges.dart';
import '../../vendors/data/vendor_models.dart';
import 'booking_message_codec.dart';

/// One submitted booking request. [eventDate] is stored as a plain DateTime
/// (date only — time-of-day isn't collected yet).
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

  /// Maps a real `/bookings` API record. Neither the vendor's display name
  /// nor the package/price/guest-count are available on this record at all
  /// — `GET /bookings/mine` doesn't include the vendor's `user` relation,
  /// and there's no package/price/guest-count field server-side to begin
  /// with — so all of it comes back out of the encoded `message` field
  /// instead (see `booking_message_codec.dart`), falling back to a generic
  /// label only for a booking this app didn't create itself.
  factory BookingModel.fromApiJson(
    Map<String, dynamic> json, {
    required String fallbackVendorName,
    required String fallbackPackageName,
  }) {
    final vendor = json['vendor'] as Map<String, dynamic>?;
    final decoded = decodeBookingMessage(
      json['message'] as String?,
      fallbackVendorName: fallbackVendorName,
      fallbackPackageName: fallbackPackageName,
    );
    return BookingModel(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String? ?? vendor?['id'] as String? ?? '',
      vendorName: decoded.vendorName,
      vendorImageAsset: (vendor?['avatarUrl'] as String?) ?? kFallbackVendorImage,
      packageName: decoded.packageName,
      packagePriceEgp: decoded.packagePriceEgp,
      eventDate: DateTime.tryParse(json['eventDate'] as String? ?? '') ?? DateTime.now(),
      guestCount: decoded.guestCount,
      notes: decoded.notes,
      status: bookingStatusFromApi(json['status'] as String?),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
