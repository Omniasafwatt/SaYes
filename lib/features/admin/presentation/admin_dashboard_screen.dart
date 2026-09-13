import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/admin_dashboard_controller.dart';

final _numberFormat = NumberFormat('#,##0', 'en_US');

/// The Admin shell's landing section — a scannable counter grid built from
/// whatever `GET /admin/dashboard` actually returns (see
/// [AdminDashboardStats]'s doc comment), plus quick links into every other
/// back-office section since there's no bottom-nav space for all of them.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  static const _icons = [
    Icons.group_rounded,
    Icons.storefront_rounded,
    Icons.calendar_month_rounded,
    Icons.rate_review_rounded,
    Icons.category_rounded,
    Icons.verified_rounded,
    Icons.pending_actions_rounded,
    Icons.workspace_premium_rounded,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statsAsync = ref.watch(adminDashboardProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(adminDashboardProvider.future),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          children: [
            Text(l10n.adminDashboardWelcome, style: context.typography.bodyLg.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.lg),
            statsAsync.when(
              data: (stats) => stats.counters.isEmpty
                  ? AppStateView(
                      icon: Icons.bar_chart_rounded,
                      title: l10n.adminDashboardEmptyTitle,
                      message: l10n.adminDashboardEmptyMessage,
                    )
                  : _StatsGrid(counters: stats.counters, icons: _icons),
              loading: () => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.5,
                children: List.generate(4, (_) => SkeletonBox(borderRadius: AppRadius.lgRadius)),
              ),
              error: (error, stackTrace) => AppStateView(
                icon: Icons.wifi_off_rounded,
                title: l10n.errorTitle,
                message: l10n.errorMessage,
                actionLabel: l10n.errorAction,
                iconColor: AppColors.error,
                iconBackground: AppColors.errorContainer,
                onAction: () => ref.invalidate(adminDashboardProvider),
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            Text(l10n.adminDashboardQuickLinks, style: context.typography.titleLg),
            const SizedBox(height: AppSpacing.sm),
            _QuickLink(icon: Icons.storefront_outlined, label: l10n.adminNavVendors, onTap: () => context.push(AppRoutes.adminVendors)),
            _QuickLink(icon: Icons.group_outlined, label: l10n.adminNavUsers, onTap: () => context.push(AppRoutes.adminUsers)),
            _QuickLink(icon: Icons.calendar_month_outlined, label: l10n.adminNavBookings, onTap: () => context.push(AppRoutes.adminBookings)),
            _QuickLink(icon: Icons.rate_review_outlined, label: l10n.adminNavReviews, onTap: () => context.push(AppRoutes.adminReviews)),
            _QuickLink(icon: Icons.category_outlined, label: l10n.adminNavCategories, onTap: () => context.push(AppRoutes.adminCategories)),
            _QuickLink(
              icon: Icons.workspace_premium_outlined,
              label: l10n.adminNavPlans,
              onTap: () => context.push(AppRoutes.adminSubscriptionPlans),
            ),
            _QuickLink(icon: Icons.query_stats_outlined, label: l10n.adminNavAnalytics, onTap: () => context.push(AppRoutes.adminAnalytics)),
            _QuickLink(icon: Icons.settings_outlined, label: l10n.adminNavSettings, onTap: () => context.push(AppRoutes.adminSettings)),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.counters, required this.icons});

  final Map<String, num> counters;
  final List<IconData> icons;

  String _humanize(String key) {
    final withSpaces = key.replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}');
    final words = withSpaces.split(RegExp(r'[_\s]+')).where((w) => w.isNotEmpty);
    return words.map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final entries = counters.entries.toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.5,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final icon = icons[index % icons.length];
        return Container(
          padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.surfaceBlush, borderRadius: AppRadius.mdRadius),
                alignment: Alignment.center,
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const Spacer(),
              Text(_numberFormat.format(entry.value), style: context.typography.headlineLg),
              Text(
                _humanize(entry.key),
                style: context.typography.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        child: InkWell(
          borderRadius: AppRadius.lgRadius,
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(label, style: context.typography.bodyLg)),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
