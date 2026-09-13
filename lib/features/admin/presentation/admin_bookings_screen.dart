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
import 'admin_labels.dart';

class AdminBookingsScreen extends ConsumerStatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  ConsumerState<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends ConsumerState<AdminBookingsScreen> {
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
      ref.read(adminBookingsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adminBookingsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.md),
            child: Wrap(
              spacing: 8,
              children: [
                for (final status in [null, ...BookingApiStatus.values])
                  ChoiceChip(
                    label: Text(status == null ? l10n.adminVendorsFilterAll : bookingStatusLabelForAdmin(l10n, status)),
                    selected: state.filters.status == status,
                    onSelected: (_) => ref.read(adminBookingsControllerProvider.notifier).setFilters(AdminBookingFilters(status: status)),
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
                  onAction: () => ref.read(adminBookingsControllerProvider.notifier).retry(),
                ),
              AdminListStatus.empty => AppStateView(
                  icon: Icons.calendar_month_outlined,
                  title: l10n.adminBookingsEmptyTitle,
                  message: l10n.adminBookingsEmptyMessage,
                ),
              AdminListStatus.success || AdminListStatus.loadingMore => RefreshIndicator(
                  onRefresh: () => ref.read(adminBookingsControllerProvider.notifier).retry(),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, 0, AppSpacing.screenMargin, AppSpacing.sectionGap),
                    itemCount: state.bookings.length + (state.status == AdminListStatus.loadingMore ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      if (index >= state.bookings.length) {
                        return const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.lg), child: Center(child: AppLoadingIndicator(size: 24)));
                      }
                      return _BookingRow(booking: state.bookings[index], l10n: l10n);
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

class _BookingRow extends ConsumerWidget {
  const _BookingRow({required this.booking, required this.l10n});

  final AdminBookingSummary booking;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateLabel = DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(booking.eventDate);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('${booking.customerName} → ${booking.vendorName}', style: context.typography.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              _StatusBadge(status: booking.status, l10n: l10n),
            ],
          ),
          const SizedBox(height: 4),
          Text('${booking.packageName} · $dateLabel', style: context.typography.caption),
          if (booking.status == BookingApiStatus.pending) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: l10n.adminBookingRejectAction,
                    variant: AppButtonVariant.text,
                    onPressed: () => ref.read(adminBookingsControllerProvider.notifier).reject(booking.id),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: l10n.adminBookingAcceptAction,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => ref.read(adminBookingsControllerProvider.notifier).accept(booking.id),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.l10n});
  final BookingApiStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      BookingApiStatus.pending => (AppColors.pendingContainer, AppColors.primary),
      BookingApiStatus.accepted => (AppColors.successContainer, AppColors.success),
      BookingApiStatus.rejected => (AppColors.errorContainer, AppColors.onErrorContainer),
      BookingApiStatus.cancelled => (AppColors.outlineNeutral, AppColors.textSecondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.fullRadius),
      child: Text(bookingStatusLabelForAdmin(l10n, status), style: context.typography.labelSm.copyWith(color: fg)),
    );
  }
}
