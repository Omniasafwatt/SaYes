import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../vendors/data/vendor_models.dart';
import '../data/vendor_listing_models.dart';
import '../data/vendor_listing_repository.dart';

/// Loads and mutates the signed-in vendor's own listing. Every mutation
/// re-reads through the repository afterwards rather than patching local
/// state by hand — the placeholder dataset is small enough that the extra
/// round trip is free, and it keeps this controller from drifting out of
/// sync with whatever the repository actually persisted.
class VendorListingController extends AsyncNotifier<VendorListingProfile> {
  @override
  Future<VendorListingProfile> build() => ref.read(vendorListingRepositoryProvider).getListing();

  Future<void> _reload() async {
    state = await AsyncValue.guard(() => ref.read(vendorListingRepositoryProvider).getListing());
  }

  Future<void> updateBusinessDetails({
    required String businessName,
    required String categoryId,
    required String city,
    required int startingPriceEgp,
    required String description,
  }) async {
    await ref.read(vendorListingRepositoryProvider).updateBusinessDetails(
          businessName: businessName,
          categoryId: categoryId,
          city: city,
          startingPriceEgp: startingPriceEgp,
          description: description,
        );
    await _reload();
  }

  Future<void> addPortfolioImage(XFile file) async {
    await ref.read(vendorListingRepositoryProvider).addPortfolioImage(file);
    await _reload();
  }

  Future<void> removePortfolioImage(String id) async {
    await ref.read(vendorListingRepositoryProvider).removePortfolioImage(id);
    await _reload();
  }

  Future<void> addPackage(PackageModel package) async {
    await ref.read(vendorListingRepositoryProvider).addPackage(package);
    await _reload();
  }

  Future<void> updatePackage(PackageModel package) async {
    await ref.read(vendorListingRepositoryProvider).updatePackage(package);
    await _reload();
  }

  Future<void> deletePackage(String id) async {
    await ref.read(vendorListingRepositoryProvider).deletePackage(id);
    await _reload();
  }
}

final vendorListingControllerProvider = AsyncNotifierProvider<VendorListingController, VendorListingProfile>(
  VendorListingController.new,
);
