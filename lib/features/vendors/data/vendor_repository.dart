import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'vendor_models.dart';

/// Contract for vendor search/listing. Screens never load "all vendors" —
/// every call is paginated, per the project brief. [filters] is optional
/// so plain-query search (Phase 7) and filtered browsing (Phase 8) share
/// one entry point.
abstract class VendorRepository {
  Future<VendorSearchPage> search({
    required String query,
    required int page,
    int pageSize = 8,
    VendorFilters? filters,
  });
}

/// TEMPORARY placeholder implementation — same honest pattern as
/// [PlaceholderAuthRepository] and [PlaceholderHomeRepository]: no backend
/// exists yet, so this simulates latency and filters an in-memory sample
/// dataset. Replace with a real Dio-backed implementation (or a real
/// search service — Elasticsearch, OpenSearch, whatever the backend picks)
/// once the API contract exists; the repository interface is deliberately
/// opaque to how search/filtering is actually implemented server-side.
class PlaceholderVendorRepository implements VendorRepository {
  static const _all = <VendorSummary>[
    VendorSummary(
      id: 'v1',
      name: 'Nour Al Sham Wedding Hall',
      imageAsset: 'assets/images/wedding_hall_zamalek.png',
      city: 'Zamalek, Cairo',
      categoryId: 'halls',
      rating: 4.9,
      reviewCount: 184,
      startingPriceEgp: 65000,
      isVerified: true,
      isFeatured: true,
    ),
    VendorSummary(
      id: 'v2',
      name: 'Maison Rêve Bridal Couture',
      imageAsset: 'assets/images/bridal_dress_couture.png',
      city: 'Mohandessin, Giza',
      categoryId: 'makeup',
      rating: 5.0,
      reviewCount: 96,
      startingPriceEgp: 28000,
      isVerified: true,
      isFeatured: true,
    ),
    VendorSummary(
      id: 'v3',
      name: 'Layla Rose Makeup Studio',
      imageAsset: 'assets/images/makeup_artist_portfolio.png',
      city: 'New Cairo',
      categoryId: 'makeup',
      rating: 4.95,
      reviewCount: 142,
      startingPriceEgp: 6000,
      isVerified: true,
      isFeatured: true,
    ),
    VendorSummary(
      id: 'v4',
      name: 'Grand Lakeview Ballroom',
      imageAsset: 'assets/images/wedding_hall_ballroom_tables.png',
      city: 'New Cairo',
      categoryId: 'halls',
      rating: 4.85,
      reviewCount: 121,
      startingPriceEgp: 45000,
    ),
    VendorSummary(
      id: 'v5',
      name: 'Amira Lens Photography',
      imageAsset: 'assets/images/bride_editorial_portrait.png',
      city: 'Zamalek, Cairo',
      categoryId: 'photographers',
      rating: 4.9,
      reviewCount: 88,
      startingPriceEgp: 15000,
      isVerified: true,
    ),
    VendorSummary(
      id: 'v6',
      name: 'Nile Palace on the Water',
      imageAsset: 'assets/images/wedding_hall_sunset_nile.png',
      city: 'Maadi, Cairo',
      categoryId: 'halls',
      rating: 4.8,
      reviewCount: 203,
      startingPriceEgp: 70000,
      isVerified: true,
    ),
    VendorSummary(
      id: 'v7',
      name: 'Belle Fleur Decor & Kosha',
      imageAsset: 'assets/images/wedding_ceremony_setup.png',
      city: 'Sheikh Zayed, Giza',
      categoryId: 'decoration',
      rating: 4.75,
      reviewCount: 67,
      startingPriceEgp: 20000,
    ),
    VendorSummary(
      id: 'v8',
      name: 'Golden Horizon Wedding Hall',
      imageAsset: 'assets/images/wedding_hall_architecture.png',
      city: 'Alexandria',
      categoryId: 'halls',
      rating: 4.7,
      reviewCount: 155,
      startingPriceEgp: 52000,
      isVerified: true,
    ),
    VendorSummary(
      id: 'v9',
      name: 'Diamond Events Planning',
      imageAsset: 'assets/images/bride_palace_staircase.png',
      city: 'Heliopolis, Cairo',
      categoryId: 'planners',
      rating: 4.88,
      reviewCount: 74,
      startingPriceEgp: 18000,
    ),
    VendorSummary(
      id: 'v10',
      name: 'Rhythm Nation DJs',
      imageAsset: 'assets/images/wedding_hall_zamalek.png',
      city: 'Cairo',
      categoryId: 'dj',
      rating: 4.6,
      reviewCount: 51,
      startingPriceEgp: 8000,
    ),
    VendorSummary(
      id: 'v11',
      name: 'Fine Taste Catering',
      imageAsset: 'assets/images/wedding_ceremony_setup.png',
      city: 'Giza',
      categoryId: 'catering',
      rating: 4.65,
      reviewCount: 112,
      startingPriceEgp: 12000,
    ),
    VendorSummary(
      id: 'v12',
      name: 'Petals & Pearls Decoration',
      imageAsset: 'assets/images/wedding_hall_ballroom_tables.png',
      city: 'New Cairo',
      categoryId: 'decoration',
      rating: 4.72,
      reviewCount: 39,
      startingPriceEgp: 16000,
    ),
    VendorSummary(
      id: 'v13',
      name: 'Royal Fleet Car Rental',
      imageAsset: 'assets/images/rings_bouquet_avatar.png',
      city: 'Cairo',
      categoryId: 'car_rental',
      rating: 4.5,
      reviewCount: 28,
      startingPriceEgp: 4000,
    ),
    VendorSummary(
      id: 'v14',
      name: 'Elegance Bridal Makeup',
      imageAsset: 'assets/images/makeup_bride_closeup.png',
      city: 'Alexandria',
      categoryId: 'makeup',
      rating: 4.82,
      reviewCount: 63,
      startingPriceEgp: 5500,
    ),
    VendorSummary(
      id: 'v15',
      name: 'Cairo Frame Photography',
      imageAsset: 'assets/images/bride_editorial_portrait.png',
      city: 'Downtown, Cairo',
      categoryId: 'photographers',
      rating: 4.77,
      reviewCount: 94,
      startingPriceEgp: 13000,
      isVerified: true,
    ),
    VendorSummary(
      id: 'v16',
      name: 'Whisper Gardens Venue',
      imageAsset: 'assets/images/wedding_hall_architecture.png',
      city: '6th of October',
      categoryId: 'halls',
      rating: 4.6,
      reviewCount: 47,
      startingPriceEgp: 38000,
    ),
    VendorSummary(
      id: 'v17',
      name: 'Timeless Vows Planners',
      imageAsset: 'assets/images/wedding_ceremony_setup.png',
      city: 'Zamalek, Cairo',
      categoryId: 'planners',
      rating: 4.9,
      reviewCount: 58,
      startingPriceEgp: 22000,
      isVerified: true,
    ),
    VendorSummary(
      id: 'v18',
      name: 'Sound Wave DJ Co.',
      imageAsset: 'assets/images/wedding_hall_sunset_nile.png',
      city: 'Giza',
      categoryId: 'dj',
      rating: 4.55,
      reviewCount: 33,
      startingPriceEgp: 7500,
    ),
    VendorSummary(
      id: 'v19',
      name: 'Nile Breeze Catering',
      imageAsset: 'assets/images/bride_palace_staircase.png',
      city: 'Maadi, Cairo',
      categoryId: 'catering',
      rating: 4.68,
      reviewCount: 81,
      startingPriceEgp: 14000,
    ),
    VendorSummary(
      id: 'v20',
      name: 'Blossom & Vine Decor',
      imageAsset: 'assets/images/bridal_dress_couture.png',
      city: 'Heliopolis, Cairo',
      categoryId: 'decoration',
      rating: 4.73,
      reviewCount: 45,
      startingPriceEgp: 17000,
    ),
  ];

  Future<void> _simulateLatency() => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<VendorSearchPage> search({
    required String query,
    required int page,
    int pageSize = 8,
    VendorFilters? filters,
  }) async {
    await _simulateLatency();
    final normalized = query.trim().toLowerCase();

    Iterable<VendorSummary> results = _all;
    if (normalized.isNotEmpty) {
      results = results.where((v) => v.name.toLowerCase().contains(normalized) || v.city.toLowerCase().contains(normalized));
    }
    if (filters != null) {
      if (filters.categoryId != null) {
        results = results.where((v) => v.categoryId == filters.categoryId);
      }
      if (filters.city != null) {
        final city = filters.city!.toLowerCase();
        results = results.where((v) => v.city.toLowerCase().contains(city));
      }
      if (filters.minRating != null) {
        results = results.where((v) => v.rating >= filters.minRating!);
      }
      results = results.where(
        (v) => v.startingPriceEgp >= filters.priceRange.start && v.startingPriceEgp <= filters.priceRange.end,
      );
    }

    final list = results.toList();
    switch (filters?.sort ?? SortOption.recommended) {
      case SortOption.highestRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.lowestPrice:
        list.sort((a, b) => a.startingPriceEgp.compareTo(b.startingPriceEgp));
      case SortOption.highestPrice:
        list.sort((a, b) => b.startingPriceEgp.compareTo(a.startingPriceEgp));
      case SortOption.featured:
        list.sort((a, b) {
          if (a.isFeatured != b.isFeatured) return a.isFeatured ? -1 : 1;
          return b.rating.compareTo(a.rating);
        });
      case SortOption.recommended:
        break;
    }

    final start = (page - 1) * pageSize;
    if (start >= list.length) return const VendorSearchPage(vendors: [], hasMore: false);
    final end = (start + pageSize).clamp(0, list.length);
    return VendorSearchPage(vendors: list.sublist(start, end), hasMore: end < list.length);
  }
}

final vendorRepositoryProvider = Provider<VendorRepository>((ref) => PlaceholderVendorRepository());
