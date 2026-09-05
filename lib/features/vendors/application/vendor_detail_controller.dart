import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/vendor_models.dart';
import '../data/vendor_repository.dart';

/// One vendor's full profile for the Vendor Details screen. A plain
/// FutureProvider is enough here — unlike Search/Listing there's no
/// pagination or mutable filter state, just "fetch this one vendor."
final vendorDetailProvider = FutureProvider.autoDispose.family<VendorDetail, String>((ref, vendorId) {
  return ref.read(vendorRepositoryProvider).getVendorDetail(vendorId);
});
