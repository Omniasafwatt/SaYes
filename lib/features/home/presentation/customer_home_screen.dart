import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/animations/app_motion.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/animations/pressable_scale.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../favorites/application/favorites_controller.dart';
import '../application/home_controller.dart';
import '../data/home_models.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

String _greetingFor(AppLocalizations l10n) {
  final hour = DateTime.now().hour;
  if (hour < 12) return l10n.homeGreetingMorning;
  if (hour < 17) return l10n.homeGreetingAfternoon;
  return l10n.homeGreetingEvening;
}

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final homeAsync = ref.watch(homeControllerProvider);
    final favorites = ref.watch(favoritesControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _HomeHeader(l10n: l10n),
            Expanded(
              child: homeAsync.when(
                data: (data) => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => ref.refresh(homeControllerProvider.future),
                  child: _HomeContent(data: data, favoriteIds: favorites, l10n: l10n),
                ),
                loading: () => const _HomeLoadingSkeleton(),
                error: (error, stackTrace) => ListView(
                  children: [
                    const SizedBox(height: AppSpacing.sectionGap * 2),
                    AppStateView(
                      icon: Icons.wifi_off_rounded,
                      title: l10n.errorTitle,
                      message: l10n.homeErrorMessage,
                      actionLabel: l10n.errorAction,
                      iconColor: AppColors.error,
                      iconBackground: AppColors.errorContainer,
                      onAction: () => ref.invalidate(homeControllerProvider),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final t = context.typography;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.sm, AppSpacing.screenMargin, AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: AppColors.surfaceBlush, shape: BoxShape.circle),
            child: const Icon(Icons.person_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_greetingFor(l10n), style: t.titleMd),
                Text(l10n.homeGreetingSubtitle, style: t.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const _NotificationBell(),
          const SizedBox(width: AppSpacing.sm),
          const LanguageSwitcher(),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, boxShadow: AppShadows.card),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 20),
          PositionedDirectional(
            top: 9,
            end: 10,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.data, required this.favoriteIds, required this.l10n});

  final HomeData data;
  final Set<String> favoriteIds;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap * 2),
      children: [
        FadeSlideIn(child: _HeroBanner(l10n: l10n)),
        const SizedBox(height: AppSpacing.lg),
        FadeSlideIn(delay: const Duration(milliseconds: 40), child: const _SearchBar()),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlideIn(
          delay: const Duration(milliseconds: 80),
          child: SectionHeader(title: l10n.homeSectionCategories),
        ),
        const SizedBox(height: AppSpacing.md),
        FadeSlideIn(
          delay: const Duration(milliseconds: 100),
          child: _CategoryRow(categories: data.categories),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlideIn(
          delay: const Duration(milliseconds: 120),
          child: SectionHeader(title: l10n.homeSectionFeatured),
        ),
        const SizedBox(height: AppSpacing.md),
        _VendorRow(
          vendors: data.featuredVendors,
          favoriteIds: favoriteIds,
          l10n: l10n,
          cardWidth: 250,
          baseDelay: 140,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlideIn(
          delay: const Duration(milliseconds: 180),
          child: SectionHeader(title: l10n.homeSectionPopular),
        ),
        const SizedBox(height: AppSpacing.md),
        _VendorRow(
          vendors: data.popularVendors,
          favoriteIds: favoriteIds,
          l10n: l10n,
          cardWidth: 210,
          baseDelay: 200,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlideIn(
          delay: const Duration(milliseconds: 240),
          child: SectionHeader(title: l10n.homeSectionCities),
        ),
        const SizedBox(height: AppSpacing.md),
        FadeSlideIn(
          delay: const Duration(milliseconds: 260),
          child: _CityRow(cities: data.cities),
        ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: ClipRRect(
        borderRadius: AppRadius.xlRadius,
        child: SizedBox(
          height: 210,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/wedding_hall_zamalek.png', fit: BoxFit.cover)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(begin: 1, end: 1.06, duration: const Duration(seconds: 10), curve: Curves.easeInOut),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withValues(alpha: 0.05), Colors.black.withValues(alpha: 0.55)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    l10n.homeHeroHeadline,
                    style: context.typography.displaySm.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.fullRadius,
          border: Border.all(color: AppColors.outlineRose),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                AppLocalizations.of(context).homeSearchHint,
                style: context.typography.bodyLg.copyWith(color: AppColors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.categories});
  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final category = categories[index];
          return PressableScale(
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(color: AppColors.surfaceBlush, shape: BoxShape.circle),
                    child: Icon(category.icon, color: AppColors.primary, size: 26),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.metadata,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VendorRow extends StatelessWidget {
  const _VendorRow({
    required this.vendors,
    required this.favoriteIds,
    required this.l10n,
    required this.cardWidth,
    required this.baseDelay,
  });

  final List<VendorSummary> vendors;
  final Set<String> favoriteIds;
  final AppLocalizations l10n;
  final double cardWidth;
  final int baseDelay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardWidth > 220 ? 300 : 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
        itemCount: vendors.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final vendor = vendors[index];
          return FadeSlideIn(
            delay: Duration(milliseconds: baseDelay + index.clamp(0, 6) * AppMotion.staggerStep.inMilliseconds),
            direction: EntranceDirection.right,
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
                  onTap: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CityRow extends StatelessWidget {
  const _CityRow({required this.cities});
  final List<CityModel> cities;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
        itemCount: cities.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final city = cities[index];
          return PressableScale(
            child: Container(
              width: 168,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.lgRadius,
                border: Border.all(color: AppColors.outlineNeutral),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.surfaceBlush, shape: BoxShape.circle),
                    child: const Icon(Icons.location_city_rounded, color: AppColors.roseGold, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(city.name, style: context.typography.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          l10n.cityVendorCount(city.vendorCount),
                          style: context.typography.metadata,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeLoadingSkeleton extends StatelessWidget {
  const _HomeLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.md),
      children: [
        SkeletonBox(height: 210, borderRadius: AppRadius.xlRadius),
        const SizedBox(height: AppSpacing.sectionGap),
        SkeletonBox(width: 160, height: 20),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            for (var i = 0; i < 4; i++) ...[
              const SkeletonBox(width: 60, height: 60, borderRadius: BorderRadius.all(Radius.circular(30))),
              if (i != 3) const SizedBox(width: AppSpacing.md),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        SkeletonBox(width: 180, height: 20),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            SkeletonVendorCard(width: 220),
            SizedBox(width: AppSpacing.md),
            SkeletonVendorCard(width: 220),
          ],
        ),
      ],
    );
  }
}
