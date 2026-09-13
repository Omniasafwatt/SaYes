import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/pagination.dart';
import '../../vendors/data/vendor_models.dart';
import 'vendor_listing_models.dart';

/// Contract for a vendor's own editable listing content — the flip side of
/// [VendorRepository] (which is customer-facing and read-only).
abstract class VendorListingRepository {
  /// Whether this account has already created its `/vendors` record. A
  /// brand-new vendor account has none yet — the app shows a one-time setup
  /// screen in that case rather than crashing on a 404 from [getListing].
  Future<bool> hasProfile();

  Future<void> createProfile({required String categoryId, required String city, required String bio});

  Future<VendorListingProfile> getListing();

  Future<void> updateBusinessDetails({
    required String businessName,
    required String categoryId,
    required String city,
    required int startingPriceEgp,
    required String description,
  });

  Future<void> addPortfolioImage(XFile file);
  Future<void> removePortfolioImage(String id);
  Future<void> addPackage(PackageModel package);
  Future<void> updatePackage(PackageModel package);
  Future<void> deletePackage(String id);
}

/// Real implementation. A vendor's "listing" isn't one API resource — it's
/// assembled from `/vendors/me` (city/bio/category), `/users/me` (the
/// display name — vendors have no name of their own, see
/// `VendorSummary.fromJson`), and that vendor's own packages/portfolio.
class ApiVendorListingRepository implements VendorListingRepository {
  ApiVendorListingRepository(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> _fetchMyVendorJson() async => await _api.get('/vendors/me') as Map<String, dynamic>;

  @override
  Future<bool> hasProfile() async {
    try {
      await _fetchMyVendorJson();
      return true;
    } on ApiException catch (error) {
      if (error.isNotFound) return false;
      rethrow;
    }
  }

  @override
  Future<void> createProfile({required String categoryId, required String city, required String bio}) async {
    await _api.post('/vendors', data: {'categoryId': categoryId, 'city': city, 'bio': bio});
  }

  @override
  Future<VendorListingProfile> getListing() async {
    final vendorJson = await _fetchMyVendorJson();
    final vendorId = vendorJson['id'] as String;

    final results = await Future.wait([
      _api.get('/users/me'),
      _api.get('/vendors/$vendorId/packages'),
      _api.get('/vendors/$vendorId/portfolio'),
    ]);
    final profileJson = results[0] as Map<String, dynamic>;
    final packages = [
      for (final item in parsePage(results[1], requestedPage: 1).items) PackageModel.fromJson(item as Map<String, dynamic>),
    ];
    final portfolio = [
      for (final item in parsePage(results[2], requestedPage: 1).items)
        PortfolioItemRef.fromJson(item as Map<String, dynamic>),
    ];

    final prices = packages.map((p) => p.priceEgp);
    final category = vendorJson['category'] as Map<String, dynamic>?;

    return VendorListingProfile(
      vendorId: vendorId,
      businessName: profileJson['name'] as String? ?? '',
      categoryId: (category?['id'] as String?) ?? vendorJson['categoryId'] as String? ?? '',
      city: vendorJson['city'] as String? ?? '',
      startingPriceEgp: prices.isEmpty ? 0 : prices.reduce((a, b) => a < b ? a : b),
      description: vendorJson['bio'] as String? ?? '',
      portfolio: portfolio,
      packages: packages,
    );
  }

  @override
  Future<void> updateBusinessDetails({
    required String businessName,
    required String categoryId,
    required String city,
    required int startingPriceEgp,
    required String description,
  }) async {
    // categoryId/startingPriceEgp are read-only server-side (category is
    // create-only; starting price is derived from packages) — the screen
    // that calls this already locks both fields, so they're just ignored
    // here rather than sent anywhere.
    final vendorJson = await _fetchMyVendorJson();
    final vendorId = vendorJson['id'] as String;
    await Future.wait([
      _api.patch('/users/me', data: {'name': businessName}),
      _api.patch('/vendors/$vendorId', data: {'city': city, 'bio': description}),
    ]);
  }

  @override
  Future<void> addPortfolioImage(XFile file) async {
    final vendorJson = await _fetchMyVendorJson();
    final vendorId = vendorJson['id'] as String;
    final multipartFile = kIsWeb
        ? MultipartFile.fromBytes(await file.readAsBytes(), filename: file.name)
        : await MultipartFile.fromFile(file.path, filename: file.name);
    await _api.postMultipart('/vendors/$vendorId/portfolio', FormData.fromMap({'file': multipartFile}));
  }

  @override
  Future<void> removePortfolioImage(String id) async {
    await _api.delete('/portfolio/$id');
  }

  @override
  Future<void> addPackage(PackageModel package) async {
    final vendorJson = await _fetchMyVendorJson();
    final vendorId = vendorJson['id'] as String;
    await _api.post('/vendors/$vendorId/packages', data: {
      'title': package.name,
      'description': encodePackageDescription(package.description, package.inclusions),
      'price': package.priceEgp,
    });
  }

  @override
  Future<void> updatePackage(PackageModel package) async {
    await _api.patch('/packages/${package.id}', data: {
      'title': package.name,
      'description': encodePackageDescription(package.description, package.inclusions),
      'price': package.priceEgp,
    });
  }

  @override
  Future<void> deletePackage(String id) async {
    await _api.delete('/packages/$id');
  }
}

final vendorListingRepositoryProvider = Provider<VendorListingRepository>(
  (ref) => ApiVendorListingRepository(ref.watch(apiClientProvider)),
);
