import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/application/user_profile_controller.dart';
import '../../profile/presentation/widgets/account_widgets.dart';

/// Profile tab for the signed-in vendor experience. Account-level settings
/// (contact info, language, notifications, logging out) are identical to
/// the customer Profile screen and share its widgets; the "Your Listing"
/// section is new here — a vendor's actual portfolio and packages aren't
/// editable yet, so each row is honest about that rather than pretending
/// the feature exists.
class VendorProfileScreen extends ConsumerWidget {
  const VendorProfileScreen({super.key});

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
                Text(l10n.vendorProfileTitle, style: t.headlineLg),
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
            Text(l10n.vendorProfileListingSection, style: t.titleLg),
            const SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
              child: Column(
                children: [
                  SettingsRow(
                    icon: Icons.photo_library_outlined,
                    title: l10n.vendorProfilePortfolio,
                    trailing: ComingSoonTag(label: l10n.vendorProfileComingSoonBadge),
                  ),
                  const Divider(height: 1),
                  SettingsRow(
                    icon: Icons.local_offer_outlined,
                    title: l10n.vendorProfilePackages,
                    trailing: ComingSoonTag(label: l10n.vendorProfileComingSoonBadge),
                  ),
                  const Divider(height: 1),
                  SettingsRow(
                    icon: Icons.storefront_outlined,
                    title: l10n.vendorProfileBusinessDetails,
                    trailing: ComingSoonTag(label: l10n.vendorProfileComingSoonBadge),
                  ),
                ],
              ),
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
