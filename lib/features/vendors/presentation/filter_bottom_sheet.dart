import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../categories/application/categories_controller.dart';
import '../application/cities_provider.dart';
import '../data/vendor_models.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// Filter/sort bottom sheet shared by Search and the vendor listing screen.
/// Edits a local draft seeded from [initialFilters] — nothing is applied
/// until the user taps Apply, so results underneath don't shift while the
/// sheet is open. The caller owns where the result goes: Search commits it
/// to its shared [vendorFiltersProvider][1], while a listing screen commits
/// it straight to that screen's own controller.
///
/// [1]: ../application/vendor_filters_controller.dart
class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key, required this.initialFilters, required this.onApply});

  final VendorFilters initialFilters;
  final ValueChanged<VendorFilters> onApply;

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late String? _categoryId;
  late String? _city;
  late double? _minRating;
  late RangeValues _priceRange;
  late SortOption _sort;

  @override
  void initState() {
    super.initState();
    final current = widget.initialFilters;
    _categoryId = current.categoryId;
    _city = current.city;
    _minRating = current.minRating;
    _priceRange = current.priceRange;
    _sort = current.sort;
  }

  void _reset() {
    setState(() {
      _categoryId = null;
      _city = null;
      _minRating = null;
      _priceRange = const RangeValues(0, 80000);
      _sort = SortOption.recommended;
    });
  }

  void _apply() {
    widget.onApply(
      VendorFilters(
        categoryId: _categoryId,
        city: _city,
        minRating: _minRating,
        priceRange: _priceRange,
        sort: _sort,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    final citiesAsync = ref.watch(citiesProvider);

    final sortLabels = <SortOption, String>{
      SortOption.recommended: l10n.sortRecommended,
      SortOption.highestRated: l10n.sortHighestRated,
      SortOption.lowestPrice: l10n.sortLowestPrice,
      SortOption.highestPrice: l10n.sortHighestPrice,
      SortOption.featured: l10n.sortFeatured,
    };

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenMargin,
          AppSpacing.sm,
          AppSpacing.screenMargin,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.filtersTitle, style: context.typography.titleLg),
                TextButton(onPressed: _reset, child: Text(l10n.filtersReset)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Text(l10n.filtersCategory, style: context.typography.titleMd),
            const SizedBox(height: AppSpacing.sm),
            categoriesAsync.when(
              data: (categories) => Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  AppChip(
                    label: l10n.filtersAllCategories,
                    selected: _categoryId == null,
                    onTap: () => setState(() => _categoryId = null),
                  ),
                  for (final category in categories)
                    AppChip(
                      label: category.name,
                      icon: category.icon,
                      selected: _categoryId == category.id,
                      onTap: () => setState(() => _categoryId = category.id),
                    ),
                ],
              ),
              loading: () => const SizedBox(height: 40),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            Text(l10n.filtersCity, style: context.typography.titleMd),
            const SizedBox(height: AppSpacing.sm),
            citiesAsync.when(
              data: (cities) => Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  AppChip(
                    label: l10n.filtersAllCities,
                    selected: _city == null,
                    onTap: () => setState(() => _city = null),
                  ),
                  for (final city in cities)
                    AppChip(
                      label: city.name,
                      selected: _city == city.name,
                      onTap: () => setState(() => _city = city.name),
                    ),
                ],
              ),
              loading: () => const SizedBox(height: 40),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            Text(l10n.filtersRating, style: context.typography.titleMd),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AppChip(
                  label: l10n.filtersAnyRating,
                  selected: _minRating == null,
                  onTap: () => setState(() => _minRating = null),
                ),
                AppChip(
                  label: l10n.filtersRating4Plus,
                  selected: _minRating == 4.0,
                  onTap: () => setState(() => _minRating = 4.0),
                ),
                AppChip(
                  label: l10n.filtersRating45Plus,
                  selected: _minRating == 4.5,
                  onTap: () => setState(() => _minRating = 4.5),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.filtersPriceRange, style: context.typography.titleMd),
                Text(
                  l10n.filtersPriceRangeValue(
                    _priceFormat.format(_priceRange.start.round()),
                    _priceFormat.format(_priceRange.end.round()),
                  ),
                  style: context.typography.labelMd.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 80000,
              divisions: 32,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.outlineRose,
              labels: RangeLabels(
                _priceFormat.format(_priceRange.start.round()),
                _priceFormat.format(_priceRange.end.round()),
              ),
              onChanged: (values) => setState(() => _priceRange = values),
            ),
            const SizedBox(height: AppSpacing.sm),

            Text(l10n.filtersSort, style: context.typography.titleMd),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final option in SortOption.values)
                  AppChip(
                    label: sortLabels[option]!,
                    selected: _sort == option,
                    onTap: () => setState(() => _sort = option),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            AppButton(label: l10n.filtersApply, onPressed: _apply),
          ],
        ),
      ),
    );
  }
}
