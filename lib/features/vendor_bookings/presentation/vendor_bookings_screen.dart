import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/vendor_bookings_controller.dart';
import '../data/vendor_booking_request.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// The vendor's incoming booking requests — the Bookings tab of
/// [VendorShell]. A pending request can be accepted or declined; the
/// change persists locally (see [PlaceholderVendorBookingsRepository]) and
/// is reflected on the Dashboard tab's stats immediately after.
class VendorBookingsScreen extends ConsumerWidget {
  const VendorBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final requestsAsync = ref.watch(vendorBookingsControllerProvider);

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
              child: requestsAsync.when(
                data: (requests) => requests.isEmpty
                    ? AppStateView(
                        icon: Icons.inbox_outlined,
                        title: l10n.vendorDashboardEmptyRequestsTitle,
                        message: l10n.vendorDashboardEmptyRequestsMessage,
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () => ref.read(vendorBookingsControllerProvider.notifier).refresh(),
                        child: _RequestsList(requests: requests, l10n: l10n),
                      ),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.errorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.read(vendorBookingsControllerProvider.notifier).refresh(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestsList extends StatelessWidget {
  const _RequestsList({required this.requests, required this.l10n});

  final List<VendorBookingRequest> requests;
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
      itemCount: requests.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final request = requests[index];
        return FadeSlideIn(
          delay: Duration(milliseconds: 30 * index.clamp(0, 6)),
          child: _RequestCard(request: request, l10n: l10n),
        );
      },
    );
  }
}

class _RequestCard extends ConsumerWidget {
  const _RequestCard({required this.request, required this.l10n});

  final VendorBookingRequest request;
  final AppLocalizations l10n;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 ? parts.last[0] : '';
    return (first + second).toUpperCase();
  }

  String _statusLabel(AppLocalizations l10n, BookingStatus status) => switch (status) {
        BookingStatus.pending => l10n.statusPending,
        BookingStatus.accepted => l10n.statusAccepted,
        BookingStatus.rejected => l10n.statusRejected,
      };

  Future<void> _confirmDecline(BuildContext context, WidgetRef ref) async {
    await showAppDialog<void>(
      context: context,
      title: l10n.vendorBookingsDeclineConfirmTitle,
      message: l10n.vendorBookingsDeclineConfirmMessage,
      primaryLabel: l10n.vendorBookingsDeclineConfirmAction,
      onPrimary: () => ref.read(vendorBookingsControllerProvider.notifier).decline(request.id),
      secondaryLabel: l10n.vendorBookingsCancelAction,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.typography;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.outlineNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: AppColors.surfaceBlush, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(_initials(request.customerName), style: t.titleMd.copyWith(color: AppColors.primary)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.customerName, style: t.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(request.packageName, style: t.bodyMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              BookingStatusBadge(status: request.status, label: _statusLabel(l10n, request.status)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.md), child: Divider()),
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  DateFormat.yMMMMd(Localizations.localeOf(context).toString()).format(request.eventDate),
                  style: t.bodyMd,
                ),
              ),
              Text(l10n.egpAmountLabel(_priceFormat.format(request.packagePriceEgp)), style: t.price),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(Icons.groups_rounded, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text(l10n.bookingSuccessGuestsLabel(request.guestCount), style: t.bodyMd),
            ],
          ),
          if (request.notes != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.surfaceBlush, borderRadius: AppRadius.mdRadius),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(request.notes!, style: t.caption)),
                ],
              ),
            ),
          ],
          if (request.status == BookingStatus.pending) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: l10n.vendorBookingsDecline,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => _confirmDecline(context, ref),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: l10n.vendorBookingsAccept,
                    onPressed: () => ref.read(vendorBookingsControllerProvider.notifier).accept(request.id),
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
