import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../vendors/data/vendor_models.dart';
import '../application/favorite_vendors_provider.dart';
import '../application/favorites_controller.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// The customer's saved vendors. Reads through [favoriteVendorsProvider],
/// which re-fetches whenever the favorited id set changes anywhere in the
/// app, so unfavoriting a card here or on any other screen stays in sync.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final vendorsAsync = ref.watch(favoriteVendorsProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.md, AppSpacing.screenMargin, AppSpacing.sm),
              child: FadeSlideIn(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.navFavorites, style: context.typography.headlineLg),
                    const LanguageSwitcher(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: vendorsAsync.when(
                data: (vendors) => vendors.isEmpty
                    ? AppStateView(
                        icon: Icons.favorite_border_rounded,
                        title: l10n.emptyFavoritesTitle,
                        message: l10n.emptyFavoritesMessage,
                        actionLabel: l10n.emptyFavoritesAction,
                        onAction: () => context.go(AppRoutes.home),
                      )
                    : _FavoritesList(vendors: vendors, l10n: l10n),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.errorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(favoriteVendorsProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesList extends ConsumerWidget {
  const _FavoritesList({required this.vendors, required this.l10n});

  final List<VendorSummary> vendors;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardWidth = MediaQuery.sizeOf(context).width - (AppSpacing.screenMargin * 2);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.sm,
        AppSpacing.screenMargin,
        AppSpacing.sectionGap,
      ),
      itemCount: vendors.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        return FadeSlideIn(
          delay: Duration(milliseconds: 30 * index.clamp(0, 6)),
          child: VendorCard(
            imageUrl: vendor.imageAsset,
            isAssetImage: !isNetworkImage(vendor.imageAsset),
            name: vendor.name,
            city: vendor.city,
            rating: vendor.rating,
            reviewCountLabel: l10n.vendorReviewCount(vendor.reviewCount),
            startingPriceLabel: l10n.vendorStartingFrom(_priceFormat.format(vendor.startingPriceEgp)),
            isVerified: vendor.isVerified,
            verifiedLabel: l10n.verifiedLabel,
            isFeatured: vendor.isFeatured,
            featuredLabel: l10n.featuredLabel,
            isFavorite: true,
            onFavoriteToggle: () => ref.read(favoritesControllerProvider.notifier).toggle(vendor.id),
            width: cardWidth,
            onTap: () => context.push(AppRoutes.vendorDetail, extra: vendor.id),
          ),
        );
      },
    );
  }
}
