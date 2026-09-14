import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/localization/locale_controller.dart';
import '../../vendors/data/vendor_models.dart';
import '../data/home_models.dart';
import '../data/home_repository.dart';

class HomeData {
  const HomeData({
    required this.categories,
    required this.featuredVendors,
    required this.popularVendors,
    required this.cities,
    required this.totalVendorCount,
  });

  final List<CategoryModel> categories;
  final List<VendorSummary> featuredVendors;
  final List<VendorSummary> popularVendors;
  final List<CityModel> cities;
  final int totalVendorCount;
}

/// Loads the whole home feed in parallel. Re-runs automatically when the
/// app language changes (it watches [localeControllerProvider]), so
/// category/city names stay in sync with the active locale without the
/// screen needing to do anything special.
class HomeController extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() async {
    final locale = ref.watch(localeControllerProvider);
    final l10n = lookupAppLocalizations(locale);
    final repository = ref.read(homeRepositoryProvider);

    final results = await Future.wait([
      repository.getCategories(l10n),
      repository.getFeaturedVendors(),
      repository.getPopularVendors(),
      repository.getPopularCities(l10n),
      repository.getTotalVendorCount(),
    ]);

    return HomeData(
      categories: results[0] as List<CategoryModel>,
      featuredVendors: results[1] as List<VendorSummary>,
      popularVendors: results[2] as List<VendorSummary>,
      cities: results[3] as List<CityModel>,
      totalVendorCount: results[4] as int,
    );
  }
}

final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeData>(HomeController.new);
