import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../../core/animations/entrance.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../favorites/application/favorites_controller.dart';
import '../application/vendor_listing_controller.dart';
import '../data/vendor_models.dart';
import 'filter_bottom_sheet.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// Arguments for [VendorListingScreen], passed via go_router's `extra`.
/// [title] is resolved by the caller (a category/city name, or a section
/// title like "Featured Vendors") since it's already localized there —
/// the screen itself never needs to know which entry point it came from.
/// [cityId] is a [CityModel.id], not that display name — see
/// [VendorFilters.cityId].
class VendorListingScreenArgs {
  const VendorListingScreenArgs({
    required this.title,
    this.categoryId,
    this.cityId,
    this.initialSort = SortOption.recommended,
  });

  final String title;
  final String? categoryId;
  final String? cityId;
  final SortOption initialSort;
}

/// Full paginated vendor listing for a category, a city, or a plain
/// browse-all (Home's "See all" on Featured/Popular). Shares the same
/// [FilterBottomSheet] as Search, but keeps its own [VendorListingController]
/// instance so its filters never bleed into Search's.
class VendorListingScreen extends ConsumerStatefulWidget {
  const VendorListingScreen({super.key, required this.args});

  final VendorListingScreenArgs args;

  @override
  ConsumerState<VendorListingScreen> createState() => _VendorListingScreenState();
}

class _VendorListingScreenState extends ConsumerState<VendorListingScreen> {
  final _scrollController = ScrollController();
  late final VendorListingArgs _key = (
    categoryId: widget.args.categoryId,
    cityId: widget.args.cityId,
    initialSort: widget.args.initialSort,
  );

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
      ref.read(vendorListingControllerProvider(_key).notifier).loadMore();
    }
  }

  Future<void> _openFilters(VendorFilters current) async {
    await showAppBottomSheet<void>(
      context: context,
      builder: (_) => FilterBottomSheet(
        initialFilters: current,
        onApply: (filters) => ref.read(vendorListingControllerProvider(_key).notifier).applyFilters(filters),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(vendorListingControllerProvider(_key));
    final favorites = ref.watch(favoritesControllerProvider);
    final filtersActive = !state.filters.isDefault;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.screenMargin, AppSpacing.sm),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Expanded(
                    child: Text(
                      widget.args.title,
                      style: context.typography.headlineSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const LanguageSwitcher(),
                  const SizedBox(width: AppSpacing.xs),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () => _openFilters(state.filters),
                        icon: const Icon(Icons.tune_rounded, color: AppColors.textPrimary),
                        tooltip: l10n.filtersButtonLabel,
                      ),
                      if (filtersActive)
                        PositionedDirectional(
                          top: 6,
                          end: 6,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: switch (state.status) {
                VendorListingStatus.loading => const _VendorListingSkeleton(),
                VendorListingStatus.error => AppStateView(
                    icon: Icons.wifi_off_rounded,
                    title: l10n.errorTitle,
                    message: l10n.vendorListingErrorMessage,
                    actionLabel: l10n.errorAction,
                    iconColor: AppColors.error,
                    iconBackground: AppColors.errorContainer,
                    onAction: () => ref.read(vendorListingControllerProvider(_key).notifier).retry(),
                  ),
                VendorListingStatus.empty => AppStateView(
                    icon: Icons.search_off_rounded,
                    title: l10n.vendorListingEmptyTitle,
                    message: l10n.vendorListingEmptyMessage,
                  ),
                VendorListingStatus.success || VendorListingStatus.loadingMore => _VendorListingResults(
                    scrollController: _scrollController,
                    state: state,
                    favoriteIds: favorites,
                    l10n: l10n,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorListingResults extends StatelessWidget {
  const _VendorListingResults({
    required this.scrollController,
    required this.state,
    required this.favoriteIds,
    required this.l10n,
  });

  final ScrollController scrollController;
  final VendorListingState state;
  final Set<String> favoriteIds;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.sizeOf(context).width - (AppSpacing.screenMargin * 2);

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.sm,
        AppSpacing.screenMargin,
        AppSpacing.sectionGap,
      ),
      itemCount: state.vendors.length + 2,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(l10n.searchResultsCount(state.vendors.length), style: context.typography.metadata),
          );
        }
        final vendorIndex = index - 1;
        if (vendorIndex >= state.vendors.length) {
          return state.status == VendorListingStatus.loadingMore
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(child: AppLoadingIndicator(size: 24)),
                )
              : const SizedBox.shrink();
        }
        final vendor = state.vendors[vendorIndex];
        return FadeSlideIn(
          delay: Duration(milliseconds: 30 * vendorIndex.clamp(0, 6)),
          child: Consumer(
            builder: (context, ref, _) {
              final isFavorite = favoriteIds.contains(vendor.id);
              return VendorCard(
                imageUrl: vendor.imageAsset,
                isAssetImage: true,
                name: vendor.name,
                city: vendor.city,
                rating: vendor.rating,
                reviewCountLabel: l10n.vendorReviewCount(vendor.reviewCount),
                startingPriceLabel: l10n.vendorStartingFrom(_priceFormat.format(vendor.startingPriceEgp)),
                isVerified: vendor.isVerified,
                verifiedLabel: l10n.verifiedLabel,
                isFeatured: vendor.isFeatured,
                featuredLabel: l10n.featuredLabel,
                isFavorite: isFavorite,
                onFavoriteToggle: () => ref.read(favoritesControllerProvider.notifier).toggle(vendor.id),
                width: cardWidth,
                onTap: () => context.push(AppRoutes.vendorDetail, extra: vendor.id),
              );
            },
          ),
        );
      },
    );
  }
}

class _VendorListingSkeleton extends StatelessWidget {
  const _VendorListingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.md),
      children: [
        SkeletonBox(height: 220, borderRadius: AppRadius.xlRadius),
        const SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 220, borderRadius: AppRadius.xlRadius),
        const SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 220, borderRadius: AppRadius.xlRadius),
      ],
    );
  }
}
