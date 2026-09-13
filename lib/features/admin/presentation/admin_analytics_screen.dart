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
import '../application/admin_analytics_controller.dart';
import '../data/admin_analytics.dart';

final _numberFormat = NumberFormat('#,##0', 'en_US');
final _dateFormat = DateFormat.yMMMd();

/// Renders the 6 `/admin/analytics/*` reports as tabs sharing one date
/// range picker (Conversion ignores the range — its endpoint takes none).
/// Every tab reads through [parseAnalyticsReport]'s generic shape rather
/// than a per-report model, since the API docs never pin down each
/// report's exact fields — see that function's doc comment.
class AdminAnalyticsScreen extends ConsumerWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: AppColors.ivory,
        body: SafeArea(
          child: Column(
            children: [
              const _DateRangeRow(),
              Material(
                color: AppColors.ivory,
                child: TabBar(
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  labelStyle: context.typography.labelMd,
                  tabs: [
                    Tab(text: l10n.adminAnalyticsRevenue),
                    Tab(text: l10n.adminAnalyticsGrowth),
                    Tab(text: l10n.adminAnalyticsBookings),
                    Tab(text: l10n.adminAnalyticsReviews),
                    Tab(text: l10n.adminAnalyticsConversion),
                    Tab(text: l10n.adminAnalyticsTopCategories),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _ReportTab(provider: adminRevenueAnalyticsProvider, l10n: l10n),
                    _ReportTab(provider: adminGrowthAnalyticsProvider, l10n: l10n),
                    _ReportTab(provider: adminBookingsAnalyticsProvider, l10n: l10n),
                    _ReportTab(provider: adminReviewsAnalyticsProvider, l10n: l10n),
                    _ReportTab(provider: adminConversionAnalyticsProvider, l10n: l10n),
                    _ReportTab(provider: adminTopCategoriesAnalyticsProvider, l10n: l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateRangeRow extends ConsumerWidget {
  const _DateRangeRow();

  Future<void> _pickRange(BuildContext context, WidgetRef ref, AdminAnalyticsDateRange current) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: current.from, end: current.to),
    );
    if (picked != null) {
      ref.read(adminAnalyticsRangeProvider.notifier).state = AdminAnalyticsDateRange(from: picked.start, to: picked.end);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final range = ref.watch(adminAnalyticsRangeProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.md, AppSpacing.screenMargin, AppSpacing.sm),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.fullRadius,
        child: InkWell(
          borderRadius: AppRadius.fullRadius,
          onTap: () => _pickRange(context, ref, range),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(borderRadius: AppRadius.fullRadius, border: Border.all(color: AppColors.outlineRose)),
            child: Row(
              children: [
                const Icon(Icons.date_range_rounded, color: AppColors.primary, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '${l10n.adminAnalyticsFrom} ${_dateFormat.format(range.from)}  ·  ${l10n.adminAnalyticsTo} ${_dateFormat.format(range.to)}',
                    style: context.typography.bodyMd,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportTab extends ConsumerWidget {
  const _ReportTab({required this.provider, required this.l10n});

  final AutoDisposeFutureProvider<AnalyticsReport> provider;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(provider);
    return reportAsync.when(
      data: (report) => (report.stats.isEmpty && report.series.isEmpty)
          ? AppStateView(icon: Icons.query_stats_rounded, title: l10n.adminAnalyticsNoDataTitle, message: l10n.adminAnalyticsNoData)
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              children: [
                if (report.stats.isNotEmpty) _StatChips(stats: report.stats),
                if (report.series.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _SeriesBars(series: report.series),
                ],
              ],
            ),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, stackTrace) => AppStateView(
        icon: Icons.wifi_off_rounded,
        title: l10n.errorTitle,
        message: l10n.errorMessage,
        actionLabel: l10n.errorAction,
        iconColor: AppColors.error,
        iconBackground: AppColors.errorContainer,
        onAction: () => ref.invalidate(provider),
      ),
    );
  }
}

class _StatChips extends StatelessWidget {
  const _StatChips({required this.stats});
  final List<AnalyticsStat> stats;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final stat in stats)
          Container(
            constraints: const BoxConstraints(minWidth: 140),
            padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_numberFormat.format(stat.value), style: context.typography.headlineSm),
                Text(stat.label, style: context.typography.caption),
              ],
            ),
          ),
      ],
    );
  }
}

class _SeriesBars extends StatelessWidget {
  const _SeriesBars({required this.series});
  final List<AnalyticsSeriesPoint> series;

  @override
  Widget build(BuildContext context) {
    final maxValue = series.map((p) => p.value).fold<num>(0, (a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final point in series)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(point.label, style: context.typography.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: AppRadius.fullRadius,
                      child: LinearProgressIndicator(
                        value: maxValue == 0 ? 0 : point.value / maxValue,
                        minHeight: 10,
                        backgroundColor: AppColors.outlineNeutral,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  SizedBox(
                    width: 48,
                    child: Text(_numberFormat.format(point.value), style: context.typography.labelMd, textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
