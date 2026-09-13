import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/session_reset.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/widgets.dart';
import '../../application/notification_preferences_controller.dart';
import '../../application/user_profile_controller.dart';
import '../../data/user_profile.dart';

/// Shared account-management widgets used by both the customer and vendor
/// Profile screens — the account concerns (contact info, language,
/// notifications, logging out) are identical across roles; only what
/// surrounds them (a vendor's listing section, say) differs per screen.

class AccountProfileCard extends ConsumerWidget {
  const AccountProfileCard({super.key, required this.profile, required this.l10n});

  final UserProfile? profile;
  final AppLocalizations l10n;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 ? parts.last[0] : '';
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.typography;
    final name = profile?.name ?? '';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.surfaceBlush, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(_initials(name), style: t.titleLg.copyWith(color: AppColors.primary)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: t.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(profile?.email ?? '', style: t.bodyMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  profile?.phone ?? l10n.profileNoPhone,
                  style: t.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.profileEditProfile,
            icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
            onPressed: () => showAppBottomSheet<void>(context: context, builder: (_) => EditProfileSheet(profile: profile, l10n: l10n)),
          ),
        ],
      ),
    );
  }
}

class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({super.key, required this.profile, required this.l10n});

  final UserProfile? profile;
  final AppLocalizations l10n;

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  late final _nameController = TextEditingController(text: widget.profile?.name ?? '');
  late final _phoneController = TextEditingController(text: widget.profile?.phone ?? '');
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    await ref.read(userProfileControllerProvider.notifier).updateProfile(name: name, phone: phone.isEmpty ? null : phone);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.sm, AppSpacing.screenMargin, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.profileEditProfile, style: context.typography.titleLg),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: l10n.profileName, controller: _nameController),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: l10n.profilePhone,
              hint: l10n.profilePhoneHint,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: l10n.profileSaveChanges, loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

/// Language toggle + notification switches, in the same card used on both
/// Profile screens.
class PreferencesCard extends ConsumerWidget {
  const PreferencesCard({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationPrefs = ref.watch(notificationPreferencesControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final t = context.typography;

    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
      child: Column(
        children: [
          SettingsRow(
            icon: Icons.language_rounded,
            title: l10n.profileLanguage,
            trailing: Text(locale.isArabic ? 'العربية' : 'English', style: t.bodyMd),
            onTap: () => ref.read(localeControllerProvider.notifier).toggle(),
          ),
          const Divider(height: 1),
          SettingsSwitchRow(
            icon: Icons.event_available_rounded,
            title: l10n.profileBookingUpdates,
            subtitle: l10n.profileBookingUpdatesSubtitle,
            value: notificationPrefs.bookingUpdates,
            onChanged: (value) => ref.read(notificationPreferencesControllerProvider.notifier).setBookingUpdates(value),
          ),
          const Divider(height: 1),
          SettingsSwitchRow(
            icon: Icons.local_offer_rounded,
            title: l10n.profilePromotions,
            subtitle: l10n.profilePromotionsSubtitle,
            value: notificationPrefs.promotions,
            onChanged: (value) => ref.read(notificationPreferencesControllerProvider.notifier).setPromotions(value),
          ),
        ],
      ),
    );
  }
}

class AccountLogOutButton extends ConsumerWidget {
  const AccountLogOutButton({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton(
      label: l10n.profileLogOut,
      variant: AppButtonVariant.secondary,
      icon: Icons.logout_rounded,
      onPressed: () async {
        await ref.read(secureStorageServiceProvider).clearSession();
        if (context.mounted) context.go(AppRoutes.onboarding);
        // Forces every session-scoped provider (profile, notifications,
        // bookings, favorites, …) to rebuild from scratch — see
        // sessionEpoch's doc comment for why this can't happen via ref
        // alone.
        sessionEpoch.value++;
      },
    );
  }
}

/// One row in a settings/info card — icon, title, optional trailing
/// content, chevron. [onTap] left null renders as informational only
/// (still shows the chevron, since a caller like the vendor listing rows
/// wants the "more to come" affordance without an actual destination yet).
class SettingsRow extends StatelessWidget {
  const SettingsRow({super.key, required this.icon, required this.title, required this.trailing, this.onTap});

  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(title, style: context.typography.bodyLg)),
            trailing,
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}

class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.typography.bodyLg),
                Text(subtitle, style: context.typography.caption),
              ],
            ),
          ),
          Switch(value: value, activeThumbColor: AppColors.primary, onChanged: onChanged),
        ],
      ),
    );
  }
}
