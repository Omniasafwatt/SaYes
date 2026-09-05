import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';

/// Placeholder for Phase 18. Real profile editing, notifications, and
/// settings land there — for now this exposes the two things that are
/// already genuinely functional (language, sign out) so the app is usable
/// end to end while the rest of the phases are built.
class ProfilePlaceholderScreen extends ConsumerWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final t = context.typography;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.profileTitle, style: t.headlineLg),
                const LanguageSwitcher(),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.lgRadius,
                boxShadow: AppShadows.card,
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(l10n.profileMoreComingSoon, style: t.bodyMd)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: l10n.profileLogOut,
              variant: AppButtonVariant.secondary,
              icon: Icons.logout_rounded,
              onPressed: () async {
                await ref.read(secureStorageServiceProvider).clearSession();
                if (context.mounted) context.go(AppRoutes.onboarding);
              },
            ),
          ],
        ),
      ),
    );
  }
}
