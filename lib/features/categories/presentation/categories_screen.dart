import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
import '../../vendors/application/vendor_listing_controller.dart';
import '../../vendors/data/vendor_models.dart';
import '../../vendors/presentation/vendor_listing_screen.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// Every category as a quick filter chip, plus a photo grid of vendors
/// across all of them — the landing state ("All" selected) is what a
/// browsing couple sees first. Tapping a specific category chip pushes the
/// same full [VendorListingScreen] every other category entry point in the
/// app already uses, so opening one category behaves identically wherever
/// you started from.
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

const _allVendorsKey = (categoryId: null, city: null, initialSort: SortOption.recommended);

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 300) {
      ref.read(vendorListingControllerProvider(_allVendorsKey).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    final listingState = ref.watch(vendorListingControllerProvider(_allVendorsKey));
    final categoryNames = {for (final c in categoriesAsync.value ?? const <CategoryModel>[]) c.id: c.name};

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
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
            _VendorGrid(state: listingState, categoryNames: categoryNames, l10n: l10n),
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
            onTap: () => context.push(
              AppRoutes.vendorListing,
              extra: VendorListingScreenArgs(categoryId: category.id, title: category.name),
            ),
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

class _VendorGrid extends ConsumerWidget {
  const _VendorGrid({required this.state, required this.categoryNames, required this.l10n});

  final VendorListingState state;
  final Map<String, String> categoryNames;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (state.status) {
      case VendorListingStatus.loading:
        return SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => SkeletonBox(borderRadius: AppRadius.lgRadius),
              childCount: 6,
            ),
          ),
        );
      case VendorListingStatus.error:
        return SliverFillRemaining(
          hasScrollBody: false,
          child: AppStateView(
            icon: Icons.wifi_off_rounded,
            title: l10n.errorTitle,
            message: l10n.categoriesErrorMessage,
            actionLabel: l10n.errorAction,
            iconColor: AppColors.error,
            iconBackground: AppColors.errorContainer,
            onAction: () => ref.read(vendorListingControllerProvider(_allVendorsKey).notifier).retry(),
          ),
        );
      case VendorListingStatus.empty:
        return SliverFillRemaining(
          hasScrollBody: false,
          child: AppStateView(
            icon: Icons.search_off_rounded,
            title: l10n.vendorListingEmptyTitle,
            message: l10n.vendorListingEmptyMessage,
          ),
        );
      case VendorListingStatus.success:
      case VendorListingStatus.loadingMore:
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, 0, AppSpacing.screenMargin, AppSpacing.sectionGap),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final vendor = state.vendors[index];
                return FadeSlideIn(
                  delay: Duration(milliseconds: 30 * index.clamp(0, 8)),
                  child: _VendorPhotoCard(
                    vendor: vendor,
                    categoryName: categoryNames[vendor.categoryId] ?? '',
                    l10n: l10n,
                    onTap: () => context.push(AppRoutes.vendorDetail, extra: vendor.id),
                  ),
                );
              },
              childCount: state.vendors.length,
            ),
          ),
        );
    }
  }
}

/// Compact browse card — the vendor's photo fills the whole tile with name,
/// category, rating, and starting price legible straight over it via a
/// gradient scrim, so a 2-column grid can show real photos densely instead
/// of the flat icon-and-color tiles this screen used before.
class _VendorPhotoCard extends StatelessWidget {
  const _VendorPhotoCard({required this.vendor, required this.categoryName, required this.l10n, this.onTap});

  final VendorSummary vendor;
  final String categoryName;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.typography;
    return PressableScale(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: AppRadius.lgRadius,
        child: AspectRatio(
          aspectRatio: 0.8,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppAssetImage(path: vendor.imageAsset),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, AppColors.scrimSolid],
                    stops: [0.45, 1],
                  ),
                ),
              ),
              if (vendor.isFeatured)
                PositionedDirectional(top: 10, start: 10, child: FeaturedBadge(label: l10n.featuredLabel)),
              if (vendor.isVerified) const PositionedDirectional(top: 10, end: 10, child: _VerifiedDot()),
              PositionedDirectional(
                bottom: 10,
                start: 12,
                end: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      vendor.name,
                      style: t.titleMd.copyWith(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            categoryName,
                            style: t.caption.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
                        const SizedBox(width: 2),
                        Text(vendor.rating.toStringAsFixed(1), style: t.labelSm.copyWith(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.vendorStartingFrom(_priceFormat.format(vendor.startingPriceEgp)),
                      style: t.caption.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerifiedDot extends StatelessWidget {
  const _VerifiedDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: const Icon(Icons.verified_rounded, size: 15, color: AppColors.gold),
    );
  }
}
