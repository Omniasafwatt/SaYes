import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/user_profile_controller.dart';
import 'widgets/account_widgets.dart';

/// Real profile editing, notification preferences, and language/log-out
/// settings — the three things the earlier placeholder promised for this
/// phase.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final t = context.typography;
    final profileAsync = ref.watch(userProfileControllerProvider);

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
            profileAsync.when(
              data: (profile) => AccountProfileCard(profile: profile, l10n: l10n),
              loading: () => SkeletonBox(height: 108, borderRadius: AppRadius.lgRadius),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            Text(l10n.profilePreferencesSection, style: t.titleLg),
            const SizedBox(height: AppSpacing.sm),
            PreferencesCard(l10n: l10n),
            const SizedBox(height: AppSpacing.xxl),
            AccountLogOutButton(l10n: l10n),
          ],
        ),
      ),
    );
  }
}
