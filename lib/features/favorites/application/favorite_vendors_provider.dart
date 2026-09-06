import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../vendors/data/vendor_models.dart';
import '../../vendors/data/vendor_repository.dart';
import 'favorites_controller.dart';

/// Full vendor cards for the Favorites screen. Re-fetches whenever the
/// favorited id set changes — favoriting/unfavoriting anywhere in the app
/// keeps this screen in sync without it needing its own toggle logic.
final favoriteVendorsProvider = FutureProvider.autoDispose<List<VendorSummary>>((ref) {
  final ids = ref.watch(favoritesControllerProvider);
  return ref.read(vendorRepositoryProvider).getVendorsByIds(ids.toList());
});
