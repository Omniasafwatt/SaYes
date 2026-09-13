import '../../../core/widgets/badges.dart';

/// The real `POST /bookings` body only accepts `{vendorId, eventDate,
/// message}` — no package, price, vendor name, or guest count field exists
/// server-side (the API's `ValidationPipe` rejects any extra field), and
/// `GET /bookings/mine` /`/bookings/incoming` don't return the vendor's
/// `user` relation either, so there's nowhere else to recover a display
/// name from. Rather than showing a blank/generic booking card, all of
/// this rides along in the one free-text `message` field behind a private
/// prefix, and is unpacked again on read. A message that doesn't carry the
/// prefix (e.g. a booking created directly through Postman/Swagger rather
/// than this app) still decodes fine — it's just treated as a plain note
/// with generic fallbacks for the rest.
const _metaPrefix = 'sayyes_meta:';

String encodeBookingMessage({
  required String vendorName,
  required String packageName,
  required int packagePriceEgp,
  required int guestCount,
  String? notes,
}) {
  final meta =
      '$_metaPrefix${Uri.encodeComponent(vendorName)}|${Uri.encodeComponent(packageName)}|$packagePriceEgp|$guestCount';
  final trimmedNotes = notes?.trim();
  return (trimmedNotes == null || trimmedNotes.isEmpty) ? meta : '$meta\n$trimmedNotes';
}

class DecodedBookingMessage {
  const DecodedBookingMessage({
    required this.vendorName,
    required this.packageName,
    required this.packagePriceEgp,
    required this.guestCount,
    required this.notes,
  });

  final String vendorName;
  final String packageName;
  final int packagePriceEgp;
  final int guestCount;
  final String? notes;
}

DecodedBookingMessage decodeBookingMessage(
  String? raw, {
  required String fallbackVendorName,
  required String fallbackPackageName,
}) {
  if (raw == null || !raw.startsWith(_metaPrefix)) {
    return DecodedBookingMessage(
      vendorName: fallbackVendorName,
      packageName: fallbackPackageName,
      packagePriceEgp: 0,
      guestCount: 0,
      notes: raw,
    );
  }
  final newlineIndex = raw.indexOf('\n');
  final metaLine = newlineIndex == -1 ? raw : raw.substring(0, newlineIndex);
  final notes = newlineIndex == -1 ? null : raw.substring(newlineIndex + 1);
  final parts = metaLine.substring(_metaPrefix.length).split('|');
  String decodedOrFallback(int index, String fallback) =>
      parts.length > index && parts[index].isNotEmpty ? Uri.decodeComponent(parts[index]) : fallback;
  return DecodedBookingMessage(
    vendorName: decodedOrFallback(0, fallbackVendorName),
    packageName: decodedOrFallback(1, fallbackPackageName),
    packagePriceEgp: parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0,
    guestCount: parts.length > 3 ? int.tryParse(parts[3]) ?? 0 : 0,
    notes: notes,
  );
}

/// The API's booking status values are uppercase (`PENDING`, `ACCEPTED`,
/// `REJECTED`) — same casing mismatch as the user-role enum elsewhere.
BookingStatus bookingStatusFromApi(String? status) =>
    BookingStatus.values.byName((status ?? 'PENDING').toLowerCase());
