import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/application/user_profile_controller.dart';
import '../application/vendor_detail_controller.dart';
import '../application/vendor_reviews_controller.dart';
import '../data/vendor_models.dart';
import '../data/vendor_repository.dart';

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

  Future<void> _openWriteReviewSheet(AppLocalizations l10n, {ReviewModel? existing}) {
    return showAppBottomSheet<void>(
      context: context,
      builder: (_) => _WriteReviewSheet(vendorId: widget.vendorId, l10n: l10n, existing: existing),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(vendorDetailProvider(widget.vendorId));
    final state = ref.watch(vendorReviewsControllerProvider(widget.vendorId));

    return Scaffold(
      backgroundColor: AppColors.ivory,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openWriteReviewSheet(l10n),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.rate_review_outlined, color: AppColors.textOnPrimary),
        label: Text(l10n.vendorReviewsWriteAction, style: context.typography.labelMd.copyWith(color: AppColors.textOnPrimary)),
      ),
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
                      return _ReviewCard(
                        review: state.reviews[reviewIndex],
                        vendorId: widget.vendorId,
                        l10n: l10n,
                        onEdit: (review) => _openWriteReviewSheet(l10n, existing: review),
                      );
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

class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({required this.review, required this.vendorId, required this.l10n, required this.onEdit});

  final ReviewModel review;
  final String vendorId;
  final AppLocalizations l10n;
  final ValueChanged<ReviewModel> onEdit;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) {
    return showAppDialog<void>(
      context: context,
      title: l10n.vendorReviewsDeleteTitle,
      message: l10n.vendorReviewsDeleteMessage,
      primaryLabel: l10n.vendorReviewsDeleteAction,
      onPrimary: () async {
        try {
          await ref.read(vendorRepositoryProvider).deleteReview(vendorId);
          ref.invalidate(vendorReviewsControllerProvider(vendorId));
          ref.invalidate(ratingBreakdownProvider(vendorId));
          ref.invalidate(vendorDetailProvider(vendorId));
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.vendorReviewsDeleteError)));
          }
        }
      },
      secondaryLabel: l10n.searchCancel,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProfile = ref.watch(userProfileControllerProvider).valueOrNull;
    final isMine = myProfile != null && myProfile.id.isNotEmpty && myProfile.id == review.authorId;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: isMine ? AppColors.primaryLight : AppColors.outlineNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(review.authorName, style: context.typography.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis)),
              Text(review.dateLabel, style: context.typography.caption),
            ],
          ),
          const SizedBox(height: 4),
          RatingStars(rating: review.rating, size: 15),
          const SizedBox(height: AppSpacing.sm),
          Text(review.comment, style: context.typography.bodyMd),
          if (isMine) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => onEdit(review), child: Text(l10n.vendorReviewsEditAction)),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Bottom sheet for a signed-in customer to submit or update their own
/// review for this vendor — `POST /vendors/:id/reviews` upserts, so this
/// same form covers writing a first review and editing an existing one.
class _WriteReviewSheet extends ConsumerStatefulWidget {
  const _WriteReviewSheet({required this.vendorId, required this.l10n, this.existing});

  final String vendorId;
  final AppLocalizations l10n;
  final ReviewModel? existing;

  @override
  ConsumerState<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends ConsumerState<_WriteReviewSheet> {
  late final _commentController = TextEditingController(text: widget.existing?.comment ?? '');
  late int _rating = widget.existing?.rating.round() ?? 0;
  bool _submitting = false;
  bool _ratingTouched = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _ratingTouched = true);
    if (_rating == 0) return;

    setState(() => _submitting = true);
    try {
      await ref.read(vendorRepositoryProvider).submitReview(
            vendorId: widget.vendorId,
            rating: _rating,
            comment: _commentController.text.trim(),
          );
      ref.invalidate(vendorReviewsControllerProvider(widget.vendorId));
      ref.invalidate(ratingBreakdownProvider(widget.vendorId));
      ref.invalidate(vendorDetailProvider(widget.vendorId));
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.l10n.vendorReviewsSubmitSuccess)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.l10n.vendorReviewsSubmitError)));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.sm, AppSpacing.screenMargin, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existing != null ? l10n.vendorReviewsEditTitle : l10n.vendorReviewsWriteTitle,
              style: context.typography.titleLg,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.vendorReviewsRatingLabel, style: context.typography.labelMd),
            const SizedBox(height: 8),
            _StarPicker(rating: _rating, onChanged: (value) => setState(() => _rating = value)),
            if (_ratingTouched && _rating == 0)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(l10n.vendorReviewsRatingRequired, style: context.typography.caption.copyWith(color: AppColors.error)),
              ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: l10n.vendorReviewsCommentLabel,
              hint: l10n.vendorReviewsCommentHint,
              controller: _commentController,
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: l10n.vendorReviewsSubmitAction, loading: _submitting, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}

class _StarPicker extends StatelessWidget {
  const _StarPicker({required this.rating, required this.onChanged});

  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var star = 1; star <= 5; star++)
          GestureDetector(
            onTap: () => onChanged(star),
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(
                star <= rating ? Icons.star_rounded : Icons.star_border_rounded,
                size: 32,
                color: AppColors.gold,
              ),
            ),
          ),
      ],
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
