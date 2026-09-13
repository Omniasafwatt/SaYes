import '../../../core/widgets/badges.dart';
import '../../bookings/data/booking_message_codec.dart';

/// A couple's booking request as the vendor sees it — the other side of a
/// customer's own `BookingModel`, linked by the same real booking id.
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

  /// Maps a real `/bookings/incoming` record — see `BookingModel.fromApiJson`
  /// (the customer-side twin of this factory) for why package/price come out
  /// of the encoded `message` field rather than their own JSON keys.
  factory VendorBookingRequest.fromApiJson(Map<String, dynamic> json) {
    final customer = (json['customer'] ?? json['user']) as Map<String, dynamic>?;
    final decoded = decodeBookingMessage(
      json['message'] as String?,
      fallbackVendorName: '',
      fallbackPackageName: 'Booking request',
    );
    return VendorBookingRequest(
      id: json['id'] as String,
      customerName: (customer?['name'] as String?) ?? 'Customer',
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
