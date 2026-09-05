import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/localization/locale_controller.dart';
import '../../home/data/home_models.dart';
import '../../home/data/home_repository.dart';

/// Backend-provided cities for the filter sheet's City chips — shares
/// [homeRepositoryProvider] with Home rather than a second data source,
/// and re-runs when the language changes so names stay localized.
final citiesProvider = FutureProvider.autoDispose<List<CityModel>>((ref) async {
  final locale = ref.watch(localeControllerProvider);
  final l10n = lookupAppLocalizations(locale);
  return ref.read(homeRepositoryProvider).getPopularCities(l10n);
});
