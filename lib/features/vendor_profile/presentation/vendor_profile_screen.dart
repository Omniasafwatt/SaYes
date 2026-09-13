import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/application/user_profile_controller.dart';
import '../../profile/presentation/widgets/account_widgets.dart';
import '../../vendor_listing/application/vendor_listing_controller.dart';

/// Profile tab for the signed-in vendor experience. Account-level settings
/// (contact info, language, notifications, logging out) are identical to
/// the customer Profile screen and share its widgets; the "Your Listing"
/// section links out to the dedicated portfolio/packages/business-details
/// management screens, each showing a live summary of what's on the
/// vendor's public listing right now.
class VendorProfileScreen extends ConsumerWidget {
  const VendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final t = context.typography;
    final profileAsync = ref.watch(userProfileControllerProvider);
    final listingAsync = ref.watch(vendorListingControllerProvider);

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
                    trailing: Text(
                      l10n.vendorListingPhotoCount(listingAsync.valueOrNull?.portfolio.length ?? 0),
                      style: t.bodyMd,
                    ),
                    onTap: () => context.push(AppRoutes.vendorPortfolioManage),
                  ),
                  const Divider(height: 1),
                  SettingsRow(
                    icon: Icons.local_offer_outlined,
                    title: l10n.vendorProfilePackages,
                    trailing: Text(
                      l10n.vendorListingPackageCount(listingAsync.valueOrNull?.packages.length ?? 0),
                      style: t.bodyMd,
                    ),
                    onTap: () => context.push(AppRoutes.vendorPackagesManage),
                  ),
                  const Divider(height: 1),
                  SettingsRow(
                    icon: Icons.storefront_outlined,
                    title: l10n.vendorProfileBusinessDetails,
                    trailing: const SizedBox.shrink(),
                    onTap: () => context.push(AppRoutes.vendorBusinessDetails),
                  ),
                  const Divider(height: 1),
                  SettingsRow(
                    icon: Icons.workspace_premium_outlined,
                    title: l10n.vendorProfileSubscription,
                    trailing: const SizedBox.shrink(),
                    onTap: () => context.push(AppRoutes.subscription),
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
