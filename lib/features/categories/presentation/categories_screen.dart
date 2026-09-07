import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/animations/pressable_scale.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/categories_controller.dart';
import '../../home/data/home_models.dart';
import '../../vendors/presentation/vendor_listing_screen.dart';

/// Every category as a quick filter chip, plus the same categories again as
/// a photo grid below — same names, same destination either way. Tapping a
/// chip or a card both push the same [VendorListingScreen] every other
/// category entry point in the app already uses, so opening one category
/// behaves identically wherever you started from.
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.categoriesScreenTitle, style: context.typography.headlineLg),
                      const LanguageSwitcher(),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: SizedBox(height: 44, child: _CategoryChipRow(categoriesAsync: categoriesAsync, l10n: l10n)),
              ),
            ),
            categoriesAsync.when(
              data: (categories) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  0,
                  AppSpacing.screenMargin,
                  AppSpacing.sectionGap,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => FadeSlideIn(
                      delay: Duration(milliseconds: 30 * index.clamp(0, 8)),
                      child: _CategoryPhotoCard(category: categories[index]),
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
                    childAspectRatio: 1.1,
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

class _CategoryChipRow extends StatelessWidget {
  const _CategoryChipRow({required this.categoriesAsync, required this.l10n});

  final AsyncValue<List<CategoryModel>> categoriesAsync;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return categoriesAsync.when(
      data: (categories) => ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return AppChip(label: l10n.categoriesFilterAll, selected: true, icon: Icons.grid_view_rounded);
          }
          final category = categories[index - 1];
          return AppChip(
            label: category.name,
            selected: false,
            icon: category.icon,
            onTap: () => _openCategory(context, category),
          );
        },
      ),
      loading: () => ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => SkeletonBox(width: 96, height: 40, borderRadius: AppRadius.fullRadius),
      ),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

void _openCategory(BuildContext context, CategoryModel category) => context.push(
      AppRoutes.vendorListing,
      extra: VendorListingScreenArgs(categoryId: category.id, title: category.name),
    );

/// One category as a photo card — the same destination as its filter chip
/// above, just a bigger, photo-led way to reach it.
class _CategoryPhotoCard extends StatelessWidget {
  const _CategoryPhotoCard({required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final t = context.typography;
    return PressableScale(
      onTap: () => _openCategory(context, category),
      child: ClipRRect(
        borderRadius: AppRadius.lgRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppAssetImage(path: category.imageAsset),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.scrimSolid],
                  stops: [0.4, 1],
                ),
              ),
            ),
            PositionedDirectional(
              top: 10,
              start: 10,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(category.icon, size: 18, color: AppColors.primary),
              ),
            ),
            PositionedDirectional(
              bottom: 12,
              start: 12,
              end: 12,
              child: Text(
                category.name,
                style: t.titleMd.copyWith(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
