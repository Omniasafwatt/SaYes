import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../animations/app_motion.dart';
import '../animations/pressable_scale.dart';
import '../localization/generated/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Bottom navigation shell for the signed-in customer experience — a
/// custom-styled dock, not the default Material [BottomNavigationBar]
/// look, per the design brief. Wraps a [StatefulNavigationShell] so each
/// tab keeps its own navigation stack and scroll position.
class CustomerShell extends StatelessWidget {
  const CustomerShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      (icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: l10n.navHome),
      (icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded, label: l10n.navExplore),
      (icon: Icons.favorite_border_rounded, activeIcon: Icons.favorite_rounded, label: l10n.navFavorites),
      (icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, label: l10n.navBookings),
      (icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: l10n.navProfile),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: AppShadows.sheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final (index, item) in items.indexed)
                  _NavItem(
                    icon: item.icon,
                    activeIcon: item.activeIcon,
                    label: item.label,
                    selected: index == navigationShell.currentIndex,
                    onTap: () => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: AppMotion.fast,
              style: context.typography.labelSm.copyWith(color: color, fontSize: 10),
              child: Text(label),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: AppMotion.fast,
              width: selected ? 14 : 0,
              height: 3,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.fullRadius),
            ),
          ],
        ),
      ),
    );
  }
}
