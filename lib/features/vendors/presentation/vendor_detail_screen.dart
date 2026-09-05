import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../../core/animations/entrance.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../categories/application/categories_controller.dart';
import '../../favorites/application/favorites_controller.dart';
import '../../home/presentation/coming_soon_screen.dart';
import '../application/vendor_detail_controller.dart';
import '../data/vendor_models.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// Full vendor profile: photo gallery, about, portfolio preview, package
/// tiers, and a review preview, with a sticky "Request Booking" CTA.
/// Booking itself is a later phase — the CTA is honest about that today,
/// same as the Favorites/Bookings tabs.
class VendorDetailScreen extends ConsumerWidget {
  const VendorDetailScreen({super.key, required this.vendorId});

  final String vendorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(vendorDetailProvider(vendorId));
    final favorites = ref.watch(favoritesControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SizedBox.expand(
        child: Stack(
        children: [
          Positioned.fill(
            child: detailAsync.when(
              data: (detail) => _VendorDetailContent(detail: detail, l10n: l10n),
              loading: () => const _VendorDetailSkeleton(),
              error: (error, stackTrace) => SafeArea(
                child: AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.vendorDetailErrorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(vendorDetailProvider(vendorId)),
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleIconButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
                  detailAsync.maybeWhen(
                    data: (detail) => FavoriteButton(
                      isFavorite: favorites.contains(detail.id),
                      onToggle: () => ref.read(favoritesControllerProvider.notifier).toggle(detail.id),
                      size: 44,
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
      bottomNavigationBar: detailAsync.maybeWhen(
        data: (detail) => _BookingBar(startingPriceEgp: detail.startingPriceEgp, l10n: l10n),
        orElse: () => null,
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: AppShadows.card),
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({required this.startingPriceEgp, required this.l10n});

  final int startingPriceEgp;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.md, AppSpacing.screenMargin, AppSpacing.md),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: AppShadows.sheet,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.vendorStartingFrom(_priceFormat.format(startingPriceEgp)),
                style: context.typography.price,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 195,
              child: AppButton(
                label: l10n.primaryButtonLabel,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ComingSoonScreen(
                      icon: Icons.calendar_month_rounded,
                      title: l10n.comingSoonBookingsTitle,
                      message: l10n.comingSoonBookingsMessage,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorDetailContent extends ConsumerWidget {
  const _VendorDetailContent({required this.detail, required this.l10n});

  final VendorDetail detail;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final categoryName = categoriesAsync.maybeWhen(
      data: (categories) => categories.where((c) => c.id == detail.categoryId).firstOrNull?.name,
      orElse: () => null,
    );

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        FadeSlideIn(child: _HeroGallery(imageAssets: detail.imageAssets)),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(detail.name, style: context.typography.headlineLg)),
                  if (detail.isVerified) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Icon(Icons.verified_rounded, color: AppColors.gold, size: 24),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded, size: 15, color: AppColors.textSecondary),
                      const SizedBox(width: 3),
                      Text(detail.city, style: context.typography.bodyMd),
                    ],
                  ),
                  if (categoryName != null)
                    Text('·', style: context.typography.bodyMd),
                  if (categoryName != null) Text(categoryName, style: context.typography.bodyMd),
                  if (detail.isFeatured) FeaturedBadge(label: l10n.featuredLabel),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              RatingSummary(rating: detail.rating, reviewsLabel: l10n.vendorReviewCount(detail.reviewCount)),
              const SizedBox(height: AppSpacing.sectionGap),

              Text(l10n.vendorDetailAbout, style: context.typography.titleLg),
              const SizedBox(height: AppSpacing.sm),
              Text(detail.description, style: context.typography.bodyLg),
              const SizedBox(height: AppSpacing.sectionGap),

              Text(l10n.vendorDetailPortfolio, style: context.typography.titleLg),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
            itemCount: detail.imageAssets.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) => AppAssetImage(
              path: detail.imageAssets[index],
              width: 140,
              height: 140,
              borderRadius: AppRadius.lgRadius,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sectionGap),
              Text(l10n.vendorDetailPackages, style: context.typography.titleLg),
              const SizedBox(height: AppSpacing.sm),
              for (final package in detail.packages) ...[
                _PackageCard(package: package, l10n: l10n),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.sectionGap - AppSpacing.sm),

              Text(l10n.vendorDetailReviews, style: context.typography.titleLg),
              const SizedBox(height: AppSpacing.sm),
              for (final review in detail.reviews) ...[
                _ReviewCard(review: review),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.sectionGap),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroGallery extends StatefulWidget {
  const _HeroGallery({required this.imageAssets});
  final List<String> imageAssets;

  @override
  State<_HeroGallery> createState() => _HeroGalleryState();
}

class _HeroGalleryState extends State<_HeroGallery> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageAssets.length,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) => AppAssetImage(path: widget.imageAssets[index], width: double.infinity, height: 340),
          ),
          if (widget.imageAssets.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < widget.imageAssets.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _page ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _page ? AppColors.surface : AppColors.surface.withValues(alpha: 0.5),
                        borderRadius: AppRadius.fullRadius,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package, required this.l10n});

  final PackageModel package;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.outlineNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(package.name, style: context.typography.titleMd)),
              const SizedBox(width: AppSpacing.sm),
              Text(l10n.egpAmountLabel(_priceFormat.format(package.priceEgp)), style: context.typography.price),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(package.description, style: context.typography.bodyMd),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.outlineNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.authorName, style: context.typography.titleMd),
              Text(review.dateLabel, style: context.typography.caption),
            ],
          ),
          const SizedBox(height: 4),
          RatingStars(rating: review.rating, size: 15),
          const SizedBox(height: AppSpacing.sm),
          Text(review.comment, style: context.typography.bodyMd),
        ],
      ),
    );
  }
}

class _VendorDetailSkeleton extends StatelessWidget {
  const _VendorDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SkeletonBox(height: 340, borderRadius: BorderRadius.zero),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SkeletonBox(width: 220, height: 26),
              SizedBox(height: AppSpacing.sm),
              SkeletonBox(width: 160, height: 16),
              SizedBox(height: AppSpacing.sectionGap),
              SkeletonBox(width: 100, height: 20),
              SizedBox(height: AppSpacing.sm),
              SkeletonBox(height: 60),
            ],
          ),
        ),
      ],
    );
  }
}
