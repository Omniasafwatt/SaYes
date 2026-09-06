import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../localization/generated/app_localizations.dart';
import 'app_nav_shell.dart';

/// Bottom navigation shell for the signed-in vendor experience — same dock
/// styling as [CustomerShell], a different (shorter) tab set: a vendor
/// manages one business, not a browsing catalog, so there's no
/// Explore/Favorites equivalent here.
class VendorShell extends StatelessWidget {
  const VendorShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppNavShell(
      navigationShell: navigationShell,
      items: [
        AppNavItemData(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded, label: l10n.navDashboard),
        AppNavItemData(
          icon: Icons.calendar_month_outlined,
          activeIcon: Icons.calendar_month_rounded,
          label: l10n.navBookings,
        ),
        AppNavItemData(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: l10n.navProfile),
      ],
    );
  }
}
