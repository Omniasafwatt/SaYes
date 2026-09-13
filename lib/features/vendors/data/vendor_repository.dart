import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/pagination.dart';
import 'vendor_models.dart';

/// Contract for vendor search/listing. Screens never load "all vendors" —
/// every call is paginated, per the project brief. [filters] is optional
/// so plain-query search and filtered browsing share one entry point.
abstract class VendorRepository {
  Future<VendorSearchPage> search({
    required String query,
    required int page,
    int pageSize = 8,
    VendorFilters? filters,
  });

  Future<VendorDetail> getVendorDetail(String id);

  /// Vendor cards for a set of ids, e.g. a customer's favorites. Order is
  /// not guaranteed to match [ids] — callers that care about order (none
  /// currently do) should re-sort client-side.
  Future<List<VendorSummary>> getVendorsByIds(List<String> ids);

  /// A vendor's full review list, paginated — the 3-review preview on
  /// Vendor Details is a slice of this same underlying data.
  Future<VendorReviewsPage> getVendorReviews({required String vendorId, required int page, int pageSize = 10});

  /// Star-rating distribution for the full Reviews screen's bar chart.
  Future<RatingBreakdown> getRatingBreakdown(String vendorId);

  /// Submits or updates the signed-in customer's own review for this
  /// vendor — the API upserts, so this covers both "write a review" and
  /// "edit my review".
  Future<void> submitReview({required String vendorId, required int rating, required String comment});

  /// Deletes the signed-in customer's own review for this vendor.
  Future<void> deleteReview(String vendorId);
}

/// The city names the app curates on Home/Search — the API has no city
/// directory of its own (vendors just carry a free-text `city` string), so
/// this doubles as both the "popular cities" list and the id→query-string
/// mapping [VendorFilters.cityId] needs to turn into a real `city` filter.
const cityNameById = {
  'cairo': 'Cairo',
  'alexandria': 'Alexandria',
  'giza': 'Giza',
  'el_gouna': 'El Gouna',
  'hurghada': 'Hurghada',
  'sharm': 'Sharm El Sheikh',
};

/// Real implementation, backed by the deployed NestJS API. Two important
/// gaps versus the old placeholder's assumptions, both unavoidable given
/// what the API actually exposes (see the Postman collection):
///
/// - **No free-text search endpoint.** `/search/vendors` filters by
///   category/city/rating/price only — there's no `q`/`name` param. When
///   [search] is called with a non-empty [VendorSearchPage] query, this
///   fetches one larger batch (capped at 100) and filters/paginates it by
///   name/city client-side, rather than searching the full ~500-vendor
///   catalog server-side.
/// - **No sort parameter.** Sorting (`SortOption`) is applied to whatever
///   single page came back, not across the whole result set.
class ApiVendorRepository implements VendorRepository {
  ApiVendorRepository(this._api);

  final ApiClient _api;

  Map<String, dynamic> _filterQuery(VendorFilters? filters) {
    final query = <String, dynamic>{};
    if (filters == null) return query;
    if (filters.categoryId != null) query['categoryId'] = filters.categoryId;
    if (filters.cityId != null) query['city'] = cityNameById[filters.cityId!] ?? filters.cityId;
    if (filters.minRating != null) query['minRating'] = filters.minRating;
    query['minPrice'] = filters.priceRange.start.round();
    query['maxPrice'] = filters.priceRange.end.round();
    return query;
  }

  void _applySort(List<VendorSummary> vendors, SortOption sort) {
    switch (sort) {
      case SortOption.highestRated:
        vendors.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.lowestPrice:
        vendors.sort((a, b) => a.startingPriceEgp.compareTo(b.startingPriceEgp));
      case SortOption.highestPrice:
        vendors.sort((a, b) => b.startingPriceEgp.compareTo(a.startingPriceEgp));
      case SortOption.featured:
        vendors.sort((a, b) {
          if (a.isFeatured != b.isFeatured) return a.isFeatured ? -1 : 1;
          return b.rating.compareTo(a.rating);
        });
      case SortOption.recommended:
        break;
    }
  }

  @override
  Future<VendorSearchPage> search({
    required String query,
    required int page,
    int pageSize = 8,
    VendorFilters? filters,
  }) async {
    final normalized = query.trim().toLowerCase();
    final filterQuery = _filterQuery(filters);

    if (normalized.isEmpty) {
      final data = await _api.get('/search/vendors', query: {'page': page, 'limit': pageSize, ...filterQuery});
      final parsed = parsePage(data, requestedPage: page);
      final vendors = [for (final item in parsed.items) VendorSummary.fromJson(item as Map<String, dynamic>)];
      _applySort(vendors, filters?.sort ?? SortOption.recommended);
      return VendorSearchPage(vendors: vendors, hasMore: parsed.hasMore);
    }

    // No server-side text search — pull one bounded batch and filter here.
    const batchLimit = 100;
    final data = await _api.get('/search/vendors', query: {'page': 1, 'limit': batchLimit, ...filterQuery});
    final parsed = parsePage(data, requestedPage: 1);
    final all = [for (final item in parsed.items) VendorSummary.fromJson(item as Map<String, dynamic>)]
        .where((v) => v.name.toLowerCase().contains(normalized) || v.city.toLowerCase().contains(normalized))
        .toList();
    _applySort(all, filters?.sort ?? SortOption.recommended);

    final start = (page - 1) * pageSize;
    if (start >= all.length) return const VendorSearchPage(vendors: [], hasMore: false);
    final end = (start + pageSize).clamp(0, all.length);
    return VendorSearchPage(vendors: all.sublist(start, end), hasMore: end < all.length);
  }

  Future<Map<String, dynamic>> _fetchVendorJson(String id) async {
    return await _api.get('/vendors/$id') as Map<String, dynamic>;
  }

  @override
  Future<VendorDetail> getVendorDetail(String id) async {
    final vendorJson = await _fetchVendorJson(id);
    List<ReviewModel> previewReviews = const [];
    try {
      final reviewsData = await _api.get('/vendors/$id/reviews', query: {'page': 1, 'limit': 3});
      final parsed = parsePage(reviewsData, requestedPage: 1);
      previewReviews = [for (final item in parsed.items) ReviewModel.fromJson(item as Map<String, dynamic>)];
    } catch (_) {
      // Reviews are a nice-to-have preview on this screen, not essential —
      // still show the vendor if only this secondary call fails.
    }
    return VendorDetail.fromJson(vendorJson, reviews: previewReviews);
  }

  @override
  Future<List<VendorSummary>> getVendorsByIds(List<String> ids) async {
    final results = await Future.wait(ids.map((id) async {
      try {
        return VendorSummary.fromJson(await _fetchVendorJson(id));
      } catch (_) {
        return null; // a favorited vendor that's since been removed, say
      }
    }));
    return results.whereType<VendorSummary>().toList();
  }

  @override
  Future<VendorReviewsPage> getVendorReviews({required String vendorId, required int page, int pageSize = 10}) async {
    final data = await _api.get('/vendors/$vendorId/reviews', query: {'page': page, 'limit': pageSize});
    final parsed = parsePage(data, requestedPage: page);
    final reviews = [for (final item in parsed.items) ReviewModel.fromJson(item as Map<String, dynamic>)];
    return VendorReviewsPage(reviews: reviews, hasMore: parsed.hasMore);
  }

  @override
  Future<RatingBreakdown> getRatingBreakdown(String vendorId) async {
    // No dedicated breakdown endpoint — approximate from a bounded batch of
    // this vendor's own reviews rather than fetching every single one.
    final data = await _api.get('/vendors/$vendorId/reviews', query: {'page': 1, 'limit': 100});
    final parsed = parsePage(data, requestedPage: 1);
    final counts = List.filled(5, 0);
    for (final item in parsed.items) {
      final rating = ((item as Map<String, dynamic>)['rating'] as num?)?.round() ?? 0;
      if (rating >= 1 && rating <= 5) counts[rating - 1]++;
    }
    return RatingBreakdown(counts: counts);
  }

  @override
  Future<void> submitReview({required String vendorId, required int rating, required String comment}) async {
    await _api.post('/vendors/$vendorId/reviews', data: {'rating': rating, 'comment': comment});
  }

  @override
  Future<void> deleteReview(String vendorId) async {
    await _api.delete('/vendors/$vendorId/reviews');
  }
}

final vendorRepositoryProvider = Provider<VendorRepository>((ref) => ApiVendorRepository(ref.watch(apiClientProvider)));
