import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/localization/locale_controller.dart';
import '../../home/data/home_models.dart';
import '../../home/data/home_repository.dart';

/// Every active category, for the full browse grid. Shares
/// [homeRepositoryProvider] with Home rather than duplicating the fetch
/// logic — the backend is the single source of truth for which categories
/// exist and are active; this just re-runs when the language changes so
/// names stay localized.
final categoriesProvider = FutureProvider.autoDispose<List<CategoryModel>>((ref) async {
  final locale = ref.watch(localeControllerProvider);
  final l10n = lookupAppLocalizations(locale);
  return ref.read(homeRepositoryProvider).getCategories(l10n);
});
