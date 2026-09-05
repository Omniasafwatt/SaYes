import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/vendor_models.dart';

/// Holds the active [VendorFilters] snapshot shared by the Search screen,
/// the filter bottom sheet, and (once wired) the filtered repository calls.
/// The bottom sheet edits a local draft and only commits here on Apply, so
/// Search results don't shift while the sheet is still open.
class VendorFiltersController extends Notifier<VendorFilters> {
  @override
  VendorFilters build() => const VendorFilters();

  void set(VendorFilters filters) => state = filters;

  void reset() => state = const VendorFilters();
}

final vendorFiltersProvider = NotifierProvider<VendorFiltersController, VendorFilters>(
  VendorFiltersController.new,
);
