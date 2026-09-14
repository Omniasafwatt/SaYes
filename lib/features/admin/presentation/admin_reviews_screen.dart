import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/admin_moderation_controllers.dart';
import '../data/admin_models.dart';

class AdminReviewsScreen extends ConsumerStatefulWidget {
  const AdminReviewsScreen({super.key});

  @override
  ConsumerState<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends ConsumerState<AdminReviewsScreen> {
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
      ref.read(adminReviewsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adminReviewsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.md),
            child: Row(
              children: [
                const Icon(Icons.visibility_off_outlined, color: AppColors.textSecondary, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(l10n.adminReviewsFilterHiddenOnly, style: context.typography.bodyMd)),
                Switch(
                  value: state.filters.hidden ?? false,
                  activeThumbColor: AppColors.primary,
                  onChanged: (value) => ref
                      .read(adminReviewsControllerProvider.notifier)
                      .setFilters(AdminReviewFilters(vendorId: state.filters.vendorId, hidden: value ? true : null)),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state.status) {
              AdminListStatus.loading => const Center(child: AppLoadingIndicator()),
              AdminListStatus.error => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.errorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.read(adminReviewsControllerProvider.notifier).retry(),
                ),
              AdminListStatus.empty => AppStateView(icon: Icons.rate_review_outlined, title: l10n.adminReviewsEmptyTitle, message: l10n.adminReviewsEmptyMessage),
              AdminListStatus.success || AdminListStatus.loadingMore => RefreshIndicator(
                  onRefresh: () => ref.read(adminReviewsControllerProvider.notifier).retry(),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, 0, AppSpacing.screenMargin, AppSpacing.sectionGap),
                    itemCount: state.reviews.length + (state.status == AdminListStatus.loadingMore ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      if (index >= state.reviews.length) {
                        return const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.lg), child: Center(child: AppLoadingIndicator(size: 24)));
                      }
                      return _ReviewRow(review: state.reviews[index], l10n: l10n);
                    },
                  ),
                ),
            },
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends ConsumerWidget {
  const _ReviewRow({required this.review, required this.l10n});

  final AdminReviewSummary review;
  final AppLocalizations l10n;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) {
    return showAppDialog<void>(
      context: context,
      title: l10n.adminReviewDeleteTitle,
      message: l10n.adminReviewDeleteMessage,
      primaryLabel: l10n.adminReviewDeleteAction,
      onPrimary: () => ref.read(adminReviewsControllerProvider.notifier).delete(review.id),
      secondaryLabel: l10n.searchCancel,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateLabel = DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(review.createdAt);
    String resolvedName = review.vendorName ?? l10n.adminReviewUnknownVendor;
    if (review.vendorName == null && review.vendorId.isNotEmpty) {
      final lookup = ref.watch(adminVendorNameProvider(review.vendorId));
      if (lookup.hasValue) resolvedName = lookup.value!;
    }
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(resolvedName, style: context.typography.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (review.isHidden)
                Container(
                  margin: const EdgeInsetsDirectional.only(end: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.outlineNeutral, borderRadius: AppRadius.fullRadius),
                  child: Text(l10n.adminReviewHiddenBadge, style: context.typography.metadata),
                ),
              RatingStars(rating: review.rating, size: 14),
            ],
          ),
          const SizedBox(height: 4),
          Text('${review.customerName} · $dateLabel', style: context.typography.caption),
          const SizedBox(height: AppSpacing.sm),
          Text(review.comment, style: context.typography.bodyMd),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => ref.read(adminReviewsControllerProvider.notifier).setHidden(review.id, !review.isHidden),
                child: Text(review.isHidden ? l10n.adminReviewUnhideAction : l10n.adminReviewHideAction),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
