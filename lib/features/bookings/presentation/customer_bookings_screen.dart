import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/bookings_controller.dart';
import '../data/booking_models.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// The customer's submitted booking requests, most-recent-first. Every
/// booking here was created by [BookingRequestScreen]'s placeholder
/// repository, so every status reads "pending" today — there's no backend
/// yet to ever move one to accepted/rejected — but the status badge itself
/// is the real, generic one already built for all three states.
class CustomerBookingsScreen extends ConsumerWidget {
  const CustomerBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bookingsAsync = ref.watch(bookingsControllerProvider);

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
                    Text(l10n.navBookings, style: context.typography.headlineLg),
                    const LanguageSwitcher(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: bookingsAsync.when(
                data: (bookings) => bookings.isEmpty
                    ? AppStateView(
                        icon: Icons.calendar_month_outlined,
                        title: l10n.customerBookingsEmptyTitle,
                        message: l10n.customerBookingsEmptyMessage,
                        actionLabel: l10n.emptyFavoritesAction,
                        onAction: () => context.go(AppRoutes.home),
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () => ref.read(bookingsControllerProvider.notifier).refresh(),
                        child: _BookingsList(bookings: bookings, l10n: l10n),
                      ),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.customerBookingsErrorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.read(bookingsControllerProvider.notifier).refresh(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  const _BookingsList({required this.bookings, required this.l10n});

  final List<BookingModel> bookings;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.sm,
        AppSpacing.screenMargin,
        AppSpacing.sectionGap,
      ),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return FadeSlideIn(
          delay: Duration(milliseconds: 30 * index.clamp(0, 6)),
          child: _BookingCard(booking: booking, l10n: l10n),
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.l10n});

  final BookingModel booking;
  final AppLocalizations l10n;

  String _statusLabel(AppLocalizations l10n, BookingStatus status) => switch (status) {
        BookingStatus.pending => l10n.statusPending,
        BookingStatus.accepted => l10n.statusAccepted,
        BookingStatus.rejected => l10n.statusRejected,
      };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.lgRadius,
      onTap: () => context.push(AppRoutes.vendorDetail, extra: booking.vendorId),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: AppColors.outlineNeutral),
        ),
        child: Column(
          children: [
            Row(
              children: [
                AppSmartImage(
                  path: booking.vendorImageAsset,
                  width: 56,
                  height: 56,
                  borderRadius: AppRadius.mdRadius,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.vendorName, style: context.typography.titleMd),
                      Text(booking.packageName, style: context.typography.bodyMd),
                    ],
                  ),
                ),
                BookingStatusBadge(status: booking.status, label: _statusLabel(l10n, booking.status)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Divider(),
            ),
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    DateFormat.yMMMMd(Localizations.localeOf(context).toString()).format(booking.eventDate),
                    style: context.typography.bodyMd,
                  ),
                ),
                Text(
                  l10n.egpAmountLabel(_priceFormat.format(booking.packagePriceEgp)),
                  style: context.typography.price,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
