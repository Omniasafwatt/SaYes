import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/application/user_profile_controller.dart';
import '../../vendor_bookings/data/vendor_booking_request.dart';
import '../application/vendor_dashboard_controller.dart';

/// Overview screen for the signed-in vendor experience — the Dashboard tab
/// of [VendorShell]. Recent requests here are the same data the Bookings
/// tab manages; rating is a separate placeholder metric (see
/// [PlaceholderVendorDashboardRepository]). The Profile tab that a vendor
/// would use to edit their actual listing lands in a later phase.
class VendorDashboardScreen extends ConsumerWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dashboardAsync = ref.watch(vendorDashboardControllerProvider);
    final profileAsync = ref.watch(userProfileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _DashboardHeader(l10n: l10n, businessName: profileAsync.value?.name),
            Expanded(
              child: dashboardAsync.when(
                data: (data) => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => ref.read(vendorDashboardControllerProvider.notifier).refresh(),
                  child: _DashboardContent(data: data, l10n: l10n),
                ),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => ListView(
                  children: [
                    const SizedBox(height: AppSpacing.sectionGap * 2),
                    AppStateView(
                      icon: Icons.wifi_off_rounded,
                      title: l10n.errorTitle,
                      message: l10n.errorMessage,
                      actionLabel: l10n.errorAction,
                      iconColor: AppColors.error,
                      iconBackground: AppColors.errorContainer,
                      onAction: () => ref.read(vendorDashboardControllerProvider.notifier).refresh(),
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

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.l10n, required this.businessName});

  final AppLocalizations l10n;
  final String? businessName;

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
            child: const Icon(Icons.storefront_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  businessName?.isNotEmpty == true ? businessName! : l10n.navDashboard,
                  style: t.titleMd,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(l10n.vendorDashboardSubtitle, style: t.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const LanguageSwitcher(),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data, required this.l10n});

  final VendorDashboardData data;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.sm,
        AppSpacing.screenMargin,
        AppSpacing.sectionGap * 2,
      ),
      children: [
        FadeSlideIn(
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.inbox_rounded,
                  value: '${data.stats.newRequestCount}',
                  label: l10n.vendorDashboardNewRequests,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(
                  icon: Icons.calendar_month_rounded,
                  value: '${data.stats.monthBookingCount}',
                  label: l10n.vendorDashboardThisMonth,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(
                  icon: Icons.star_rounded,
                  value: data.stats.rating.toStringAsFixed(1),
                  label: l10n.vendorDashboardRating,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlideIn(
          delay: const Duration(milliseconds: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.vendorDashboardRecentRequestsTitle, style: context.typography.headlineSm),
              if (data.recentRequests.isNotEmpty)
                TextButton(
                  onPressed: () => context.go(AppRoutes.vendorBookings),
                  child: Text(l10n.vendorDashboardViewAll),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (data.recentRequests.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: AppStateView(
              icon: Icons.inbox_outlined,
              title: l10n.vendorDashboardEmptyRequestsTitle,
              message: l10n.vendorDashboardEmptyRequestsMessage,
            ),
          )
        else
          for (final (index, request) in data.recentRequests.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.md),
            FadeSlideIn(
              delay: Duration(milliseconds: 40 * (index + 2)),
              child: _RequestPreviewCard(request: request, l10n: l10n),
            ),
          ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.typography;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: t.titleLg),
          const SizedBox(height: 2),
          Text(label, style: t.caption, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _RequestPreviewCard extends StatelessWidget {
  const _RequestPreviewCard({required this.request, required this.l10n});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.outlineNeutral),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: AppColors.surfaceBlush, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              _initials(request.customerName),
              style: context.typography.titleMd.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.customerName, style: context.typography.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(request.packageName, style: context.typography.bodyMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  DateFormat.yMMMMd(Localizations.localeOf(context).toString()).format(request.eventDate),
                  style: context.typography.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          BookingStatusBadge(status: request.status, label: _statusLabel(l10n, request.status)),
        ],
      ),
    );
  }
}
