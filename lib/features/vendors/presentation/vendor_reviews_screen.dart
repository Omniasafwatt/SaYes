import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/vendor_detail_controller.dart';
import '../application/vendor_reviews_controller.dart';
import '../data/vendor_models.dart';

/// Full, paginated review list for a vendor, with a star-rating breakdown
/// bar chart at the top. Reached via "See all" on the Vendor Details
/// review preview.
class VendorReviewsScreen extends ConsumerStatefulWidget {
  const VendorReviewsScreen({super.key, required this.vendorId});

  final String vendorId;

  @override
  ConsumerState<VendorReviewsScreen> createState() => _VendorReviewsScreenState();
}

class _VendorReviewsScreenState extends ConsumerState<VendorReviewsScreen> {
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
      ref.read(vendorReviewsControllerProvider(widget.vendorId).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(vendorDetailProvider(widget.vendorId));
    final state = ref.watch(vendorReviewsControllerProvider(widget.vendorId));

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
                      detailAsync.maybeWhen(data: (detail) => detail.name, orElse: () => l10n.vendorDetailReviews),
                      style: context.typography.headlineSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const LanguageSwitcher(),
                ],
              ),
            ),
            Expanded(
              child: switch (state.status) {
                VendorReviewsStatus.loading => const _ReviewsSkeleton(),
                VendorReviewsStatus.error => AppStateView(
                    icon: Icons.wifi_off_rounded,
                    title: l10n.errorTitle,
                    message: l10n.vendorReviewsErrorMessage,
                    actionLabel: l10n.errorAction,
                    iconColor: AppColors.error,
                    iconBackground: AppColors.errorContainer,
                    onAction: () => ref.read(vendorReviewsControllerProvider(widget.vendorId).notifier).retry(),
                  ),
                VendorReviewsStatus.empty => AppStateView(
                    icon: Icons.rate_review_outlined,
                    title: l10n.vendorReviewsEmptyTitle,
                    message: l10n.vendorReviewsEmptyMessage,
                  ),
                VendorReviewsStatus.success || VendorReviewsStatus.loadingMore => ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenMargin,
                      AppSpacing.sm,
                      AppSpacing.screenMargin,
                      AppSpacing.sectionGap,
                    ),
                    itemCount: state.reviews.length + 2,
                    separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _RatingBreakdownCard(vendorId: widget.vendorId, detailAsync: detailAsync, l10n: l10n);
                      }
                      final reviewIndex = index - 1;
                      if (reviewIndex >= state.reviews.length) {
                        return state.status == VendorReviewsStatus.loadingMore
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                                child: Center(child: AppLoadingIndicator(size: 24)),
                              )
                            : const SizedBox.shrink();
                      }
                      return _ReviewCard(review: state.reviews[reviewIndex]);
                    },
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingBreakdownCard extends ConsumerWidget {
  const _RatingBreakdownCard({required this.vendorId, required this.detailAsync, required this.l10n});

  final String vendorId;
  final AsyncValue<VendorDetail> detailAsync;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownAsync = ref.watch(ratingBreakdownProvider(vendorId));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.outlineNeutral),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          detailAsync.maybeWhen(
            data: (detail) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(detail.rating.toStringAsFixed(1), style: context.typography.displaySm),
                const SizedBox(height: 4),
                RatingStars(rating: detail.rating, size: 16),
                const SizedBox(height: 4),
                Text(l10n.vendorReviewCount(detail.reviewCount), style: context.typography.metadata),
              ],
            ),
            orElse: () => const SizedBox(width: 60, height: 60),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: breakdownAsync.maybeWhen(
              data: (breakdown) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var star = 5; star >= 1; star--)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text('$star', style: context.typography.metadata),
                          const SizedBox(width: 4),
                          const Icon(Icons.star_rounded, size: 12, color: AppColors.gold),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: AppRadius.fullRadius,
                              child: LinearProgressIndicator(
                                value: breakdown.total == 0 ? 0 : breakdown.counts[star - 1] / breakdown.total,
                                minHeight: 6,
                                backgroundColor: AppColors.outlineNeutral,
                                valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              orElse: () => const SizedBox(height: 60),
            ),
          ),
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

class _ReviewsSkeleton extends StatelessWidget {
  const _ReviewsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        SkeletonBox(height: 140, borderRadius: AppRadius.lgRadius),
        const SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 100, borderRadius: AppRadius.lgRadius),
        const SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 100, borderRadius: AppRadius.lgRadius),
      ],
    );
  }
}
