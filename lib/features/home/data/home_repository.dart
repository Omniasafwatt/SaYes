import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/pagination.dart';
import '../../vendors/data/vendor_models.dart';
import '../../vendors/data/vendor_repository.dart';
import 'home_models.dart';

/// Contract for the customer home feed. Categories, vendors, and cities are
/// all backend-owned per the project brief — admins can add a new category
/// or vendor without any Flutter release. Screens only ever read through
/// this interface.
abstract class HomeRepository {
  Future<List<CategoryModel>> getCategories(AppLocalizations l10n);
  Future<List<VendorSummary>> getFeaturedVendors();
  Future<List<VendorSummary>> getPopularVendors();
  Future<List<CityModel>> getPopularCities(AppLocalizations l10n);
}

/// One real category's presentation details — the API only knows a
/// category's `slug`/`name`/`id`; the icon and cover image are a purely
/// client-side concern, so they're keyed off the slug here. The 8 slugs
/// below are exactly what the live server has seeded; an unrecognized
/// slug (a category an admin adds later) still renders, just with a
/// generic icon/asset rather than crashing.
class _CategoryPresentation {
  const _CategoryPresentation(this.icon, this.imageAsset);
  final IconData icon;
  final String imageAsset;
}

const _categoryPresentationBySlug = {
  'photographer': _CategoryPresentation(Icons.camera_alt_rounded, 'assets/images/categories/photographer.png'),
  'makeup-artist': _CategoryPresentation(Icons.brush_rounded, 'assets/images/categories/makeup_artist.png'),
  'wedding-hall': _CategoryPresentation(Icons.villa_rounded, 'assets/images/categories/wedding_halls.png'),
  'wedding-planner': _CategoryPresentation(Icons.event_note_rounded, 'assets/images/categories/wedding_planner.png'),
  'dj': _CategoryPresentation(Icons.headphones_rounded, 'assets/images/categories/djs.png'),
  'catering': _CategoryPresentation(Icons.restaurant_rounded, 'assets/images/categories/catering.png'),
  'decoration': _CategoryPresentation(Icons.local_florist_rounded, 'assets/images/categories/decoration.png'),
  'car-rental': _CategoryPresentation(Icons.directions_car_filled_rounded, 'assets/images/categories/car_rental.png'),
};

const _fallbackCategoryPresentation = _CategoryPresentation(Icons.celebration_rounded, kFallbackVendorImage);

/// City names curated for the Home/Search "popular cities" row — the API
/// doesn't have a city directory (vendors just carry a free-text `city`
/// string), so this list, and the localized display names below, are a
/// client-side concern. Ids match [cityNameById] in `vendor_repository.dart`.
const _cityIds = ['cairo', 'alexandria', 'giza', 'el_gouna', 'hurghada', 'sharm'];

/// Real implementation, backed by the deployed NestJS API.
class ApiHomeRepository implements HomeRepository {
  ApiHomeRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<CategoryModel>> getCategories(AppLocalizations l10n) async {
    final data = await _api.get('/categories') as List;
    return [
      for (final item in data.cast<Map<String, dynamic>>())
        CategoryModel(
          id: item['id'] as String,
          name: item['name'] as String? ?? '',
          icon: (_categoryPresentationBySlug[item['slug']] ?? _fallbackCategoryPresentation).icon,
          imageAsset: (_categoryPresentationBySlug[item['slug']] ?? _fallbackCategoryPresentation).imageAsset,
        ),
    ];
  }

  /// Neither endpoint the app calls "featured" or "popular" actually
  /// exists server-side — there's just `/search/vendors`. Both methods
  /// pull one bounded batch and pick the top N by rating/review count,
  /// which is the same heuristic [VendorSummary.isFeatured] already uses.
  Future<List<VendorSummary>> _topVendors({required int count, bool requireFeatured = false}) async {
    final data = await _api.get('/search/vendors', query: {'page': 1, 'limit': 50});
    final parsed = parsePage(data, requestedPage: 1);
    final vendors = [for (final item in parsed.items) VendorSummary.fromJson(item as Map<String, dynamic>)];
    final pool = requireFeatured ? vendors.where((v) => v.isFeatured).toList() : vendors;
    pool.sort((a, b) {
      final ratingCompare = b.rating.compareTo(a.rating);
      return ratingCompare != 0 ? ratingCompare : b.reviewCount.compareTo(a.reviewCount);
    });
    return pool.take(count).toList();
  }

  @override
  Future<List<VendorSummary>> getFeaturedVendors() async {
    final featured = await _topVendors(count: 6, requireFeatured: true);
    if (featured.isNotEmpty) return featured;
    return _topVendors(count: 6);
  }

  @override
  Future<List<VendorSummary>> getPopularVendors() => _topVendors(count: 8);

  @override
  Future<List<CityModel>> getPopularCities(AppLocalizations l10n) async {
    final names = <String, String>{
      'cairo': l10n.cityCairo,
      'alexandria': l10n.cityAlexandria,
      'giza': l10n.cityGiza,
      'el_gouna': l10n.cityElGouna,
      'hurghada': l10n.cityHurghada,
      'sharm': l10n.citySharmElSheikh,
    };
    final counts = await Future.wait(_cityIds.map((id) async {
      try {
        final data = await _api.get('/search/vendors', query: {'page': 1, 'limit': 1, 'city': cityNameById[id]});
        final parsed = parsePage(data, requestedPage: 1);
        return (data is Map ? (data['meta']?['total'] as num?)?.toInt() : null) ?? parsed.items.length;
      } catch (_) {
        return 0;
      }
    }));
    return [
      for (var i = 0; i < _cityIds.length; i++)
        CityModel(id: _cityIds[i], name: names[_cityIds[i]]!, vendorCount: counts[i]),
    ];
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) => ApiHomeRepository(ref.watch(apiClientProvider)));
