import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../../core/animations/app_motion.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/animations/floating_petals.dart';
import '../../../core/animations/pressable_scale.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../favorites/application/favorites_controller.dart';
import '../../notifications/presentation/notification_bell.dart';
import '../application/home_controller.dart';
import '../../vendors/data/vendor_models.dart';
import '../../vendors/presentation/vendor_listing_screen.dart';
import '../data/home_models.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

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
            const _HomeHeader(),
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
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.sm, AppSpacing.screenMargin, AppSpacing.sm),
      child: SizedBox(
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(color: AppColors.surfaceBlush, shape: BoxShape.circle),
                  child: const Icon(Icons.person_rounded, color: AppColors.primary),
                ),
                const Spacer(),
                const NotificationBell(),
                const SizedBox(width: AppSpacing.sm),
                const LanguageSwitcher(),
              ],
            ),
            const _HomeWordmark(),
          ],
        ),
      ),
    );
  }
}

/// Centered brand wordmark for the home nav — replaces the old text
/// greeting. Same calm script treatment as the splash logo (not bold),
/// with a soft tinted shadow for depth; forced LTR so "SayYes" never
/// mirrors under Arabic.
class _HomeWordmark extends StatelessWidget {
  const _HomeWordmark();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          'SayYes',
          style: TextStyle(
            fontFamily: AppFontFamily.wordmark,
            fontWeight: FontWeight.w400,
            fontSize: 30,
            height: 1,
            color: AppColors.primary,
            shadows: [
              Shadow(color: AppColors.primaryDeep.withValues(alpha: 0.25), offset: const Offset(0, 1.5), blurRadius: 4),
            ],
          ),
        ),
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
        FadeSlideIn(child: _HeroSection(l10n: l10n, categories: data.categories)),
        const SizedBox(height: _HeroSection.categoryOverlap + AppSpacing.sectionGap),
        FadeSlideIn(delay: const Duration(milliseconds: 40), child: const _SearchBar()),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlideIn(delay: const Duration(milliseconds: 80), child: _TrustStatsRow(l10n: l10n, data: data)),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlideIn(
          delay: const Duration(milliseconds: 120),
          child: SectionHeader(
            title: l10n.homeSectionFeatured,
            actionLabel: l10n.homeSeeAll,
            onAction: () => context.push(
              AppRoutes.vendorListing,
              extra: VendorListingScreenArgs(title: l10n.homeSectionFeatured, initialSort: SortOption.featured),
            ),
          ),
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
          child: SectionHeader(
            title: l10n.homeSectionPopular,
            actionLabel: l10n.homeSeeAll,
            onAction: () => context.push(
              AppRoutes.vendorListing,
              extra: VendorListingScreenArgs(title: l10n.homeSectionPopular),
            ),
          ),
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
          delay: const Duration(milliseconds: 220),
          child: SectionHeader(title: l10n.homeSectionInspiration),
        ),
        const SizedBox(height: AppSpacing.md),
        FadeSlideIn(delay: const Duration(milliseconds: 230), child: _InspirationSection(l10n: l10n)),
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

/// Full-bleed hero photo with the category row floating half over its
/// bottom edge — the category circles overlap the image by
/// [categoryOverlap], so a caller must reserve that much extra space
/// below this widget before the next section.
class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.l10n, required this.categories});
  final AppLocalizations l10n;
  final List<CategoryModel> categories;

  static const categoryOverlap = 64.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _HeroBanner(l10n: l10n),
        PositionedDirectional(
          start: 0,
          end: 0,
          bottom: -categoryOverlap,
          child: _CategoryRow(categories: categories),
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
    return SizedBox(
      height: 270,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/samantha-gades-CsrwM-bHQIg-unsplash.jpg', fit: BoxFit.cover)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 1, end: 1.06, duration: const Duration(seconds: 10), curve: Curves.easeInOut),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withValues(alpha: 0.35), Colors.black.withValues(alpha: 0.05)],
              ),
            ),
          ),
          const FloatingPetals(petalCount: 6, color: Colors.white, maxOpacity: 0.4),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: AppSpacing.screenMargin, end: AppSpacing.screenMargin),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.homeHeroHeadline,
                      textAlign: TextAlign.end,
                      style: context.typography.headlineLg.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.homeHeroSubtitle,
                      textAlign: TextAlign.end,
                      style: context.typography.bodyMd.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                    ),
                    const SizedBox(height: 14),
                    AppButton(
                      label: l10n.homeHeroCta,
                      icon: Icons.arrow_forward_rounded,
                      expand: false,
                      onPressed: () => context.go(AppRoutes.explore),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      child: PressableScale(
        onTap: () => context.push(AppRoutes.search),
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
      ),
    );
  }
}

/// Three trust signals in a single elevated strip — a quiet "you're in good
/// company" cue right under the search bar, before any vendor content has
/// even loaded. Every number here is real: vendor count comes from
/// `/search/vendors`'s own `meta.total` (a dedicated 1-item fetch, not the
/// batch already loaded for the carousels below), categories/cities counts
/// are just the length of the lists this same screen already fetched —
/// there's no "happy couples" endpoint to source a customer count from, so
/// that slot shows categories instead of a number nobody can verify.
class _TrustStatsRow extends StatelessWidget {
  const _TrustStatsRow({required this.l10n, required this.data});
  final AppLocalizations l10n;
  final HomeData data;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (icon: Icons.verified_rounded, value: _priceFormat.format(data.totalVendorCount), label: l10n.homeStatsVendorsLabel),
      (icon: Icons.category_rounded, value: _priceFormat.format(data.categories.length), label: l10n.homeStatsCategoriesLabel),
      (icon: Icons.location_city_rounded, value: _priceFormat.format(data.cities.length), label: l10n.homeStatsCitiesLabel),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
        child: Row(
          children: [
            for (final (i, stat) in stats.indexed) ...[
              if (i != 0)
                SizedBox(height: 40, child: VerticalDivider(width: 1, thickness: 1, color: AppColors.ivory.withValues(alpha: 0.25))),
              Expanded(
                child: Column(
                  children: [
                    Icon(stat.icon, color: AppColors.ivory, size: 22),
                    const SizedBox(height: 6),
                    Text(stat.value, style: context.typography.headlineSm.copyWith(color: AppColors.ivory)),
                    const SizedBox(height: 2),
                    Text(
                      stat.label,
                      style: context.typography.metadata.copyWith(color: AppColors.ivory.withValues(alpha: 0.8)),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// An asymmetric photo collage — one tall tile beside two stacked ones —
/// deliberately different from the horizontal-scroll rows everywhere else
/// on this page, so the eye gets a beat of visual variety before the final
/// Cities section. Each tile is a mood, not a filter: there's no backend
/// concept of "wedding themes" yet, so tapping one is an honest shortcut
/// into Explore rather than a fake, unimplemented filter.
class _InspirationSection extends StatelessWidget {
  const _InspirationSection({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: SizedBox(
        height: 260,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _InspirationTile(
                imageAsset: 'assets/images/maria-orlova-BruuboWUC_U-unsplash.jpg',
                tag: l10n.homeInspirationPalaceTag,
                caption: l10n.homeInspirationPalaceCaption,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _InspirationTile(
                      imageAsset: 'assets/images/brittney-weng-Yy1tmz_G3uQ-unsplash.jpg',
                      tag: l10n.homeInspirationSeasideTag,
                      caption: l10n.homeInspirationSeasideCaption,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: _InspirationTile(
                      imageAsset: 'assets/images/nyana-stoica-Mhb0KT7iVjU-unsplash.jpg',
                      tag: l10n.homeInspirationGardenTag,
                      caption: l10n.homeInspirationGardenCaption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InspirationTile extends StatelessWidget {
  const _InspirationTile({required this.imageAsset, required this.tag, required this.caption});

  final String imageAsset;
  final String tag;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      borderRadius: AppRadius.xlRadius,
      onTap: () => context.go(AppRoutes.explore),
      child: ClipRRect(
        borderRadius: AppRadius.xlRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imageAsset, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                  stops: const [0.45, 1],
                ),
              ),
            ),
            PositionedDirectional(
              top: 10,
              start: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.bronze, borderRadius: AppRadius.fullRadius),
                child: Text(
                  tag,
                  style: context.typography.labelSm.copyWith(color: Colors.white, letterSpacing: 1),
                ),
              ),
            ),
            PositionedDirectional(
              bottom: 10,
              start: 12,
              end: 12,
              child: Text(
                caption,
                style: context.typography.titleMd.copyWith(color: Colors.white, fontFamily: AppFontFamily.latinSerif),
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
            onTap: () => context.push(
              AppRoutes.vendorListing,
              extra: VendorListingScreenArgs(categoryId: category.id, title: category.name),
            ),
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.outlineRose),
                      boxShadow: AppShadows.card,
                    ),
                    child: ClipOval(
                      child: Image.asset(category.imageAsset, fit: BoxFit.cover),
                    ),
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
                  isFavorite: isFavorite,
                  onFavoriteToggle: () => ref.read(favoritesControllerProvider.notifier).toggle(vendor.id),
                  width: cardWidth,
                  onTap: () => context.push(AppRoutes.vendorDetail, extra: vendor.id),
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
            onTap: () => context.push(
              AppRoutes.vendorListing,
              extra: VendorListingScreenArgs(cityId: city.id, title: city.name),
            ),
            child: Container(
              width: 168,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.lgRadius,
                boxShadow: AppShadows.card,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.ivory.withValues(alpha: 0.18), shape: BoxShape.circle),
                    child: const Icon(Icons.location_city_rounded, color: AppColors.ivory, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          city.name,
                          style: context.typography.titleMd.copyWith(color: AppColors.ivory),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          l10n.cityVendorCount(city.vendorCount),
                          style: context.typography.metadata.copyWith(color: AppColors.ivory.withValues(alpha: 0.8)),
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
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.md),
      children: [
        const SkeletonBox(height: 270, width: double.infinity),
        const SizedBox(height: AppSpacing.sectionGap + 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 160, height: 20),
              const SizedBox(height: AppSpacing.sectionGap),
              SkeletonBox(width: 180, height: 20),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    SkeletonVendorCard(width: 210),
                    SizedBox(width: AppSpacing.md),
                    SkeletonVendorCard(width: 210),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
