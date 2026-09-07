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

  Future<VendorDetail> getVendorDetail(String id);

  /// Vendor cards for a set of ids, e.g. a customer's favorites. Order is
  /// not guaranteed to match [ids] — callers that care about order (none
  /// currently do) should re-sort client-side.
  Future<List<VendorSummary>> getVendorsByIds(List<String> ids);

  /// A vendor's full review list, paginated — the 3-review preview on
  /// Vendor Details is a slice of this same underlying data.
  Future<VendorReviewsPage> getVendorReviews({required String vendorId, required int page, int pageSize = 10});

  /// Star-rating distribution for the full Reviews screen's bar chart.
  /// Cheap on its own (doesn't require fetching every review) even against
  /// a real backend, so it's a separate call from [getVendorReviews].
  Future<RatingBreakdown> getRatingBreakdown(String vendorId);
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

  /// [VendorFilters.cityId] to the (unlocalized) keyword actually present
  /// in [VendorSummary.city] strings like "Zamalek, Cairo" — a real backend
  /// would filter by a real city id server-side; this placeholder's mock
  /// vendors only carry free-text city names, so matching has to go
  /// through this lookup instead of comparing ids directly.
  static const _cityKeywords = {
    'cairo': 'Cairo',
    'alexandria': 'Alexandria',
    'giza': 'Giza',
    'el_gouna': 'El Gouna',
    'hurghada': 'Hurghada',
    'sharm': 'Sharm El Sheikh',
  };

  static const _descriptionByCategory = {
    'photographers':
        '{name} blends editorial composition with candid storytelling, so the album reads like the day itself rather than a performance of it.',
    'makeup':
        '{name} tailors every look to your skin, your dress, and the light you\'ll be photographed in, with a trial session included so wedding-day nerves are the only surprise.',
    'halls':
        '{name} pairs grand architecture with a team that handles the choreography of a wedding night — lighting, flow, and timing — so you can just be present in it.',
    'planners':
        '{name} takes the hundred small decisions off your plate and turns them into one clear plan, checking in exactly as often as you want and no more.',
    'dj': '{name} reads a room the way a good host does, building the night instead of just running a set list, with equipment that disappears into the venue.',
    'catering':
        '{name} builds the menu around your families\' tastes rather than a fixed package, with a tasting session before you commit to a single dish.',
    'decoration':
        '{name} designs the kosha and table styling as one continuous look, sourcing flowers and fabric to match the season and the venue\'s own light.',
    'car_rental':
        '{name} maintains a fleet built for one job — the arrival — with a driver who knows the venue routes and the timing down to the minute.',
  };

  static const _packageTiersByCategory = <String, List<(String, String, double, List<String>)>>{
    'photographers': [
      (
        'Essential Coverage',
        'One photographer, 6 hours, edited digital gallery.',
        1.0,
        ['1 photographer, 6 hours', 'Fully edited digital gallery', 'Online delivery within 3 weeks'],
      ),
      (
        'Full Day Story',
        'Two photographers, full-day coverage, engagement shoot included.',
        1.6,
        ['2 photographers, full-day coverage', 'Engagement shoot included', 'Printed 30-page album'],
      ),
      (
        'Cinematic Duo',
        'Photo and videography team, same-day highlight reel, premium album.',
        2.4,
        ['Photo + videography team', 'Same-day edit highlight reel', 'Premium leather-bound album'],
      ),
    ],
    'makeup': [
      (
        'Bridal Day-Of',
        'Bridal makeup and hair, on-site, wedding day only.',
        1.0,
        ['Bridal makeup and hair', 'On-site at your venue', 'Touch-up kit included'],
      ),
      (
        'Trial + Day-Of',
        'One trial session plus full wedding-day styling.',
        1.5,
        ['1 trial session', 'Full wedding-day styling', 'False lashes and airbrush finish'],
      ),
      (
        'Bridal Party',
        'Bride plus up to 4 bridesmaids, on-site team.',
        2.2,
        ['Bride + up to 4 bridesmaids', 'On-site team of 3 stylists', 'Trial session for the bride'],
      ),
    ],
    'halls': [
      (
        'Silver',
        'Venue rental, standard lighting, in-house tables and chairs.',
        1.0,
        ['Venue rental (up to 8 hours)', 'Standard lighting rig', 'In-house tables and chairs'],
      ),
      (
        'Gold',
        'Silver plus upgraded lighting, welcome area, and valet.',
        1.5,
        ['Everything in Silver', 'Upgraded ambient lighting', 'Welcome area and valet service'],
      ),
      (
        'Platinum',
        'Full venue exclusivity, custom lighting design, dedicated coordinator.',
        2.2,
        ['Full venue exclusivity', 'Custom lighting design', 'Dedicated on-site coordinator'],
      ),
    ],
    'planners': [
      (
        'Month-Of Coordination',
        'Final vendor confirmations and full day-of coordination.',
        1.0,
        ['Final vendor confirmations', 'Full day-of coordination', 'Timeline built 1 month out'],
      ),
      (
        'Partial Planning',
        'Vendor sourcing and planning support from 3 months out.',
        1.8,
        ['Vendor sourcing and negotiation', 'Planning support from 3 months out', 'Day-of coordination included'],
      ),
      (
        'Full Planning',
        'End-to-end planning from engagement to wedding day.',
        2.8,
        ['End-to-end planning from engagement', 'Budget tracking and vendor management', 'Unlimited planning check-ins'],
      ),
    ],
    'dj': [
      (
        'Reception Set',
        'DJ and sound system, up to 5 hours.',
        1.0,
        ['DJ and sound system', 'Up to 5 hours coverage', 'Wireless mic for speeches'],
      ),
      (
        'Full Night',
        'DJ, MC hosting, and dance-floor lighting, up to 8 hours.',
        1.6,
        ['DJ + MC hosting', 'Dance-floor lighting rig', 'Up to 8 hours coverage'],
      ),
      (
        'Premium Production',
        'Full night plus live percussionist and custom lighting rig.',
        2.3,
        ['Everything in Full Night', 'Live percussionist', 'Custom uplighting design'],
      ),
    ],
    'catering': [
      (
        'Essential Menu',
        'Three-course plated menu, standard service staff.',
        1.0,
        ['3-course plated menu', 'Standard service staff', 'Standard tableware included'],
      ),
      (
        'Signature Menu',
        'Five-course menu with live cooking station.',
        1.6,
        ['5-course menu', 'Live cooking station', 'Upgraded tableware and linens'],
      ),
      (
        'Luxury Tasting Menu',
        'Chef\'s tasting menu, premium bar service, dedicated staff.',
        2.4,
        ['Chef\'s tasting menu', 'Premium bar service', 'Dedicated service staff'],
      ),
    ],
    'decoration': [
      (
        'Essential Kosha',
        'Kosha backdrop and stage florals.',
        1.0,
        ['Kosha backdrop design', 'Stage floral arrangements', 'Setup and breakdown included'],
      ),
      (
        'Full Venue Styling',
        'Kosha, table centerpieces, and entrance styling.',
        1.7,
        ['Kosha backdrop design', 'Table centerpieces', 'Entrance and aisle styling'],
      ),
      (
        'Signature Design',
        'Fully custom floral design across every space.',
        2.6,
        ['Fully custom floral concept', 'Design across every space', 'Dedicated on-site florist team'],
      ),
    ],
    'car_rental': [
      (
        'Classic Arrival',
        'One vehicle, decorated, with driver.',
        1.0,
        ['1 decorated vehicle', 'Professional driver', 'Ribbon and floral trim'],
      ),
      (
        'Bridal Party Fleet',
        'Three vehicles for the couple and immediate family.',
        2.2,
        ['3 vehicles', 'Covers couple + immediate family', 'Matching decoration across fleet'],
      ),
      (
        'Full Convoy',
        'Five vehicles plus a lead car for the couple.',
        3.5,
        ['5 vehicles + lead car', 'Coordinated convoy route', 'Premium decoration on lead car'],
      ),
    ],
  };

  static const _galleryPoolByCategory = <String, List<String>>{
    'photographers': [
      'assets/images/bride_editorial_portrait.png',
      'assets/images/bride_palace_staircase.png',
      'assets/images/wedding_ceremony_setup.png',
    ],
    'makeup': [
      'assets/images/makeup_artist_portfolio.png',
      'assets/images/makeup_bride_closeup.png',
      'assets/images/bride_editorial_portrait.png',
    ],
    'halls': [
      'assets/images/wedding_hall_zamalek.png',
      'assets/images/wedding_hall_ballroom_tables.png',
      'assets/images/wedding_hall_sunset_nile.png',
      'assets/images/wedding_hall_architecture.png',
    ],
    'planners': [
      'assets/images/wedding_ceremony_setup.png',
      'assets/images/bride_palace_staircase.png',
      'assets/images/wedding_hall_ballroom_tables.png',
    ],
    'dj': ['assets/images/wedding_hall_zamalek.png', 'assets/images/wedding_ceremony_setup.png'],
    'catering': ['assets/images/wedding_ceremony_setup.png', 'assets/images/wedding_hall_ballroom_tables.png'],
    'decoration': [
      'assets/images/wedding_ceremony_setup.png',
      'assets/images/bridal_dress_couture.png',
      'assets/images/wedding_hall_ballroom_tables.png',
    ],
    'car_rental': ['assets/images/rings_bouquet_avatar.png', 'assets/images/wedding_hall_zamalek.png'],
  };

  static const _reviewComments = [
    'Everything was exactly as promised — communication was clear from the first call to the wedding day itself.',
    'They handled a last-minute change without missing a beat. Genuinely grateful.',
    'Worth every pound. The attention to detail showed in ways we didn\'t even ask for.',
    'A few small hiccups on timing, but the team recovered quickly and it didn\'t affect the day.',
    'Professional, warm, and exactly the vibe we wanted for our wedding.',
    'Booked them after seeing a friend\'s wedding and they didn\'t disappoint.',
  ];

  static const _reviewerNames = ['Nour K.', 'Ahmed S.', 'Mariam T.', 'Youssef A.', 'Hana M.', 'Omar F.'];

  static const _reviewDateLabels = ['2 weeks ago', '1 month ago', '3 months ago', '5 months ago'];

  Future<void> _simulateLatency() => Future.delayed(const Duration(milliseconds: 500));

  /// One synthetic review at [index] for [vendor] — deterministic, so the
  /// same index always produces the same review. Shared by the Vendor
  /// Details preview (indices 0-2) and the full paginated Reviews screen,
  /// so the preview is a genuine slice of the same data, not a separate
  /// fabrication.
  ReviewModel _reviewAt(VendorSummary vendor, int index) {
    final seed = vendor.id.hashCode.abs();
    final wobble = ((seed + index) % 5) - 2; // -2..2, centered on the vendor's own rating
    return ReviewModel(
      id: '${vendor.id}-rev$index',
      authorName: _reviewerNames[(seed + index) % _reviewerNames.length],
      rating: (vendor.rating + wobble * 0.2).clamp(3.0, 5.0),
      comment: _reviewComments[(seed + index) % _reviewComments.length],
      dateLabel: _reviewDateLabels[(seed + index) % _reviewDateLabels.length],
    );
  }

  @override
  Future<VendorDetail> getVendorDetail(String id) async {
    await _simulateLatency();
    final vendor = _all.firstWhere((v) => v.id == id);

    final tiers = _packageTiersByCategory[vendor.categoryId] ?? _packageTiersByCategory['halls']!;
    final packages = [
      for (var i = 0; i < tiers.length; i++)
        PackageModel(
          id: '${vendor.id}-pkg$i',
          name: tiers[i].$1,
          description: tiers[i].$2,
          priceEgp: (vendor.startingPriceEgp * tiers[i].$3).round(),
          inclusions: tiers[i].$4,
        ),
    ];

    final reviews = [for (var i = 0; i < 3; i++) _reviewAt(vendor, i)];

    final gallery = _galleryPoolByCategory[vendor.categoryId] ?? const [];
    final imageAssets = [
      vendor.imageAsset,
      ...gallery.where((asset) => asset != vendor.imageAsset),
    ];

    return VendorDetail(
      id: vendor.id,
      name: vendor.name,
      imageAssets: imageAssets,
      city: vendor.city,
      categoryId: vendor.categoryId,
      rating: vendor.rating,
      reviewCount: vendor.reviewCount,
      startingPriceEgp: vendor.startingPriceEgp,
      description: (_descriptionByCategory[vendor.categoryId] ?? _descriptionByCategory['halls']!)
          .replaceAll('{name}', vendor.name),
      packages: packages,
      reviews: reviews,
      isVerified: vendor.isVerified,
      isFeatured: vendor.isFeatured,
    );
  }

  @override
  Future<VendorReviewsPage> getVendorReviews({required String vendorId, required int page, int pageSize = 10}) async {
    await _simulateLatency();
    final vendor = _all.firstWhere((v) => v.id == vendorId);
    final total = vendor.reviewCount;
    final start = (page - 1) * pageSize;
    if (start >= total) return const VendorReviewsPage(reviews: [], hasMore: false);
    final end = (start + pageSize).clamp(0, total);
    final reviews = [for (var i = start; i < end; i++) _reviewAt(vendor, i)];
    return VendorReviewsPage(reviews: reviews, hasMore: end < total);
  }

  @override
  Future<RatingBreakdown> getRatingBreakdown(String vendorId) async {
    await _simulateLatency();
    final vendor = _all.firstWhere((v) => v.id == vendorId);
    // Weight each star bucket by closeness to the vendor's average rating,
    // so a 4.9-rated vendor skews heavily toward 5-star and a 4.5-rated one
    // still shows a plausible scattering of 3s and 4s.
    final weights = [
      for (var star = 1; star <= 5; star++) (1 - (vendor.rating - star).abs() / 2.5).clamp(0.05, 1.0),
    ];
    final weightSum = weights.reduce((a, b) => a + b);
    final counts = [for (final w in weights) ((w / weightSum) * vendor.reviewCount).round()];
    final roundingDrift = vendor.reviewCount - counts.reduce((a, b) => a + b);
    counts[4] += roundingDrift; // reconcile rounding against the 5-star bucket
    return RatingBreakdown(counts: counts);
  }

  @override
  Future<List<VendorSummary>> getVendorsByIds(List<String> ids) async {
    await _simulateLatency();
    final idSet = ids.toSet();
    return _all.where((v) => idSet.contains(v.id)).toList();
  }

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
      if (filters.cityId != null) {
        final keyword = (_cityKeywords[filters.cityId] ?? filters.cityId!).toLowerCase();
        results = results.where((v) => v.city.toLowerCase().contains(keyword));
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
