import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/profile/application/user_profile_controller.dart';
import '../localization/generated/app_localizations.dart';
import '../session_reset.dart';
import '../storage/secure_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_router.dart';

/// Deliberately not another bottom-nav dock — the admin back-office has too
/// many sections for that, and a control-panel-style dark side drawer over
/// a charcoal app bar reads as a distinct "you're in the back office now"
/// register, versus the ivory/bottom-dock look everywhere else in the app.
/// Still built on the same [StatefulNavigationShell] pattern as
/// [CustomerShell]/[VendorShell] so each section keeps its own stack.
class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _sections = [
    _AdminSection(icon: Icons.space_dashboard_outlined, activeIcon: Icons.space_dashboard_rounded, labelKey: 'dashboard'),
    _AdminSection(icon: Icons.storefront_outlined, activeIcon: Icons.storefront_rounded, labelKey: 'vendors'),
    _AdminSection(icon: Icons.group_outlined, activeIcon: Icons.group_rounded, labelKey: 'users'),
    _AdminSection(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, labelKey: 'bookings'),
    _AdminSection(icon: Icons.rate_review_outlined, activeIcon: Icons.rate_review_rounded, labelKey: 'reviews'),
    _AdminSection(icon: Icons.category_outlined, activeIcon: Icons.category_rounded, labelKey: 'categories'),
    _AdminSection(icon: Icons.workspace_premium_outlined, activeIcon: Icons.workspace_premium_rounded, labelKey: 'plans'),
    _AdminSection(icon: Icons.query_stats_outlined, activeIcon: Icons.query_stats_rounded, labelKey: 'analytics'),
    _AdminSection(icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded, labelKey: 'settings'),
  ];

  String _label(AppLocalizations l10n, String key) => switch (key) {
        'dashboard' => l10n.adminNavDashboard,
        'vendors' => l10n.adminNavVendors,
        'users' => l10n.adminNavUsers,
        'bookings' => l10n.adminNavBookings,
        'reviews' => l10n.adminNavReviews,
        'categories' => l10n.adminNavCategories,
        'plans' => l10n.adminNavPlans,
        'analytics' => l10n.adminNavAnalytics,
        'settings' => l10n.adminNavSettings,
        _ => key,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(userProfileControllerProvider);
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      drawer: Drawer(
        backgroundColor: AppColors.textPrimary,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Icon(Icons.shield_moon_rounded, color: AppColors.textPrimary, size: 22),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.adminPanelTitle,
                            style: context.typography.titleLg.copyWith(color: Colors.white),
                          ),
                          Text(
                            profileAsync.valueOrNull?.name ?? '',
                            style: context.typography.caption.copyWith(color: Colors.white.withValues(alpha: 0.6)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12, height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  children: [
                    for (final (index, section) in _sections.indexed)
                      _DrawerItem(
                        icon: section.icon,
                        activeIcon: section.activeIcon,
                        label: _label(l10n, section.labelKey),
                        selected: index == currentIndex,
                        onTap: () {
                          Navigator.of(context).pop();
                          navigationShell.goBranch(index, initialLocation: index == currentIndex);
                        },
                      ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12, height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _DrawerItem(
                  icon: Icons.logout_rounded,
                  activeIcon: Icons.logout_rounded,
                  label: l10n.profileLogOut,
                  selected: false,
                  iconColor: AppColors.primaryLight,
                  onTap: () async {
                    Navigator.of(context).pop();
                    await ref.read(secureStorageServiceProvider).clearSession();
                    if (context.mounted) context.go(AppRoutes.onboarding);
                    sessionEpoch.value++;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.textPrimary,
        foregroundColor: Colors.white,
        // The global AppBarTheme pins icon color to AppColors.textPrimary
        // (dark) for the ivory app bars everywhere else — invisible against
        // this shell's dark bar, so it's overridden explicitly here.
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          _label(l10n, _sections[currentIndex].labelKey),
          style: context.typography.titleLg.copyWith(color: Colors.white),
        ),
      ),
      body: navigationShell,
    );
  }
}

class _AdminSection {
  const _AdminSection({required this.icon, required this.activeIcon, required this.labelKey});
  final IconData icon;
  final IconData activeIcon;
  final String labelKey;
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.gold : (iconColor ?? Colors.white.withValues(alpha: 0.85));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      child: Material(
        color: selected ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: AppRadius.mdRadius,
        child: InkWell(
          borderRadius: AppRadius.mdRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                Icon(selected ? activeIcon : icon, color: color, size: 20),
                const SizedBox(width: AppSpacing.md),
                Text(label, style: context.typography.bodyLg.copyWith(color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
