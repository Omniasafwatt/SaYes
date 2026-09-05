import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
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

/// TEMPORARY placeholder implementation — there is no backend yet (see the
/// same note on [PlaceholderAuthRepository]). Returns realistic sample data
/// so every screen built on top of this (Home, and later Categories/Search/
/// Vendor Listing) can be built and tested now. Replace with a real
/// Dio-backed implementation once the API contract exists; nothing above
/// this class should need to change.
class PlaceholderHomeRepository implements HomeRepository {
  Future<void> _simulateLatency() => Future.delayed(const Duration(milliseconds: 700));

  @override
  Future<List<CategoryModel>> getCategories(AppLocalizations l10n) async {
    await _simulateLatency();
    return [
      CategoryModel(id: 'photographers', name: l10n.homeCategoryPhotographers, icon: Icons.camera_alt_rounded),
      CategoryModel(id: 'makeup', name: l10n.homeCategoryMakeup, icon: Icons.brush_rounded),
      CategoryModel(id: 'halls', name: l10n.homeCategoryHalls, icon: Icons.villa_rounded),
      CategoryModel(id: 'planners', name: l10n.homeCategoryPlanners, icon: Icons.event_note_rounded),
      CategoryModel(id: 'dj', name: l10n.homeCategoryDj, icon: Icons.headphones_rounded),
      CategoryModel(id: 'catering', name: l10n.homeCategoryCatering, icon: Icons.restaurant_rounded),
      CategoryModel(id: 'decoration', name: l10n.homeCategoryDecoration, icon: Icons.local_florist_rounded),
      CategoryModel(id: 'car_rental', name: l10n.homeCategoryCarRental, icon: Icons.directions_car_filled_rounded),
    ];
  }

  @override
  Future<List<VendorSummary>> getFeaturedVendors() async {
    await _simulateLatency();
    return const [
      VendorSummary(
        id: 'v1',
        name: 'Nour Al Sham Wedding Hall',
        imageAsset: 'assets/images/wedding_hall_zamalek.png',
        city: 'Zamalek, Cairo',
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
        rating: 4.95,
        reviewCount: 142,
        startingPriceEgp: 6000,
        isVerified: true,
        isFeatured: true,
      ),
    ];
  }

  @override
  Future<List<VendorSummary>> getPopularVendors() async {
    await _simulateLatency();
    return const [
      VendorSummary(
        id: 'v4',
        name: 'Grand Lakeview Ballroom',
        imageAsset: 'assets/images/wedding_hall_ballroom_tables.png',
        city: 'New Cairo',
        rating: 4.85,
        reviewCount: 121,
        startingPriceEgp: 45000,
      ),
      VendorSummary(
        id: 'v5',
        name: 'Amira Lens Photography',
        imageAsset: 'assets/images/bride_editorial_portrait.png',
        city: 'Zamalek, Cairo',
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
        rating: 4.75,
        reviewCount: 67,
        startingPriceEgp: 20000,
      ),
    ];
  }

  @override
  Future<List<CityModel>> getPopularCities(AppLocalizations l10n) async {
    await _simulateLatency();
    return [
      CityModel(id: 'cairo', name: l10n.cityCairo, vendorCount: 1240),
      CityModel(id: 'alexandria', name: l10n.cityAlexandria, vendorCount: 480),
      CityModel(id: 'giza', name: l10n.cityGiza, vendorCount: 610),
      CityModel(id: 'el_gouna', name: l10n.cityElGouna, vendorCount: 160),
      CityModel(id: 'hurghada', name: l10n.cityHurghada, vendorCount: 140),
      CityModel(id: 'sharm', name: l10n.citySharmElSheikh, vendorCount: 95),
    ];
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) => PlaceholderHomeRepository());
