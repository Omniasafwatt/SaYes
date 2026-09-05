import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/animations/pressable_scale.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/categories_controller.dart';
import '../../home/data/home_models.dart';
import '../../vendors/presentation/vendor_listing_screen.dart';

/// Full category browse grid — every active category the backend returns,
/// with no client-side list of "the" categories anywhere. An admin adding
/// a new category shows up here automatically on next load.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.md, AppSpacing.screenMargin, 0),
              sliver: SliverToBoxAdapter(
                child: FadeSlideIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.categoriesScreenTitle, style: context.typography.headlineLg),
                          const LanguageSwitcher(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(l10n.categoriesScreenSubtitle, style: context.typography.bodyMd),
                    ],
                  ),
                ),
              ),
            ),
            categoriesAsync.when(
              data: (categories) => SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.screenMargin),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.3,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => FadeSlideIn(
                      delay: Duration(milliseconds: 40 * index.clamp(0, 10)),
                      child: _CategoryTile(category: categories[index], colorIndex: index),
                    ),
                    childCount: categories.length,
                  ),
                ),
              ),
              loading: () => SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.screenMargin),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.3,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SkeletonBox(borderRadius: AppRadius.lgRadius),
                    childCount: 8,
                  ),
                ),
              ),
              error: (error, stackTrace) => SliverFillRemaining(
                hasScrollBody: false,
                child: AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.categoriesErrorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(categoriesProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _kTileTints = [
  AppColors.primaryLight,
  AppColors.gold,
  AppColors.roseGold,
  AppColors.primary,
];

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.colorIndex});

  final CategoryModel category;
  final int colorIndex;

  @override
  Widget build(BuildContext context) {
    final tint = _kTileTints[colorIndex % _kTileTints.length];
    return PressableScale(
      onTap: () => context.push(
        AppRoutes.vendorListing,
        extra: VendorListingScreenArgs(categoryId: category.id, title: category.name),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [tint.withValues(alpha: 0.16), AppColors.surface],
          ),
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: tint.withValues(alpha: 0.25)),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, boxShadow: AppShadows.card),
              child: Icon(category.icon, color: tint, size: 22),
            ),
            Text(
              category.name,
              style: context.typography.titleMd,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
