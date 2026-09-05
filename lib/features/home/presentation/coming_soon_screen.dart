import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Shared shell for nav tabs whose real feature hasn't been built yet
/// (Explore, Favorites, Bookings land in later phases). Honest
/// "not built yet" copy, not a fake empty state pretending the feature
/// exists with zero data.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.sm, AppSpacing.screenMargin, 0),
                child: LanguageSwitcher(),
              ),
            ),
            Expanded(child: AppStateView(icon: icon, title: title, message: message)),
          ],
        ),
      ),
    );
  }
}
