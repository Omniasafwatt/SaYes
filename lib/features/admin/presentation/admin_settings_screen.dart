import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/presentation/widgets/account_widgets.dart';
import '../application/admin_settings_controller.dart';
import '../data/admin_models.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(adminSettingsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: settingsAsync.when(
        data: (settings) => _SettingsForm(settings: settings, l10n: l10n),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (error, stackTrace) => AppStateView(
          icon: Icons.wifi_off_rounded,
          title: l10n.errorTitle,
          message: l10n.errorMessage,
          actionLabel: l10n.errorAction,
          iconColor: AppColors.error,
          iconBackground: AppColors.errorContainer,
          onAction: () => ref.invalidate(adminSettingsControllerProvider),
        ),
      ),
    );
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({required this.settings, required this.l10n});

  final SystemSettings settings;
  final AppLocalizations l10n;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  late SystemSettings _draft = widget.settings;
  late final _trialDaysController = TextEditingController(text: widget.settings.trialDays.toString());
  late final _uploadMaxSizeController = TextEditingController(text: widget.settings.uploadMaxSizeMb.toString());
  late final _uploadTypesController = TextEditingController(text: widget.settings.uploadAllowedTypes.join(', '));
  bool _saving = false;

  @override
  void dispose() {
    _trialDaysController.dispose();
    _uploadMaxSizeController.dispose();
    _uploadTypesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final settings = _draft.copyWith(
      trialDays: int.tryParse(_trialDaysController.text.trim()) ?? _draft.trialDays,
      uploadMaxSizeMb: int.tryParse(_uploadMaxSizeController.text.trim()) ?? _draft.uploadMaxSizeMb,
      uploadAllowedTypes: _uploadTypesController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
    );
    final success = await ref.read(adminSettingsControllerProvider.notifier).save(settings);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? widget.l10n.adminSettingsSavedMessage : widget.l10n.adminSettingsErrorMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.md, AppSpacing.screenMargin, AppSpacing.sectionGap),
      children: [
        Text(l10n.adminSettingsGeneralSection, style: context.typography.titleLg),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          child: Column(
            children: [
              SettingsSwitchRow(
                icon: Icons.how_to_reg_outlined,
                title: l10n.adminSettingsRegistrationEnabled,
                subtitle: l10n.adminSettingsRegistrationEnabledSubtitle,
                value: _draft.registrationEnabled,
                onChanged: (value) => setState(() => _draft = _draft.copyWith(registrationEnabled: value)),
              ),
              const Divider(height: 1),
              SettingsSwitchRow(
                icon: Icons.build_outlined,
                title: l10n.adminSettingsMaintenanceMode,
                subtitle: l10n.adminSettingsMaintenanceModeSubtitle,
                value: _draft.maintenanceMode,
                onChanged: (value) => setState(() => _draft = _draft.copyWith(maintenanceMode: value)),
              ),
              const Divider(height: 1),
              SettingsSwitchRow(
                icon: Icons.credit_card_outlined,
                title: l10n.adminSettingsSubscriptionRequired,
                subtitle: l10n.adminSettingsSubscriptionRequiredSubtitle,
                value: _draft.subscriptionRequired,
                onChanged: (value) => setState(() => _draft = _draft.copyWith(subscriptionRequired: value)),
              ),
              const Divider(height: 1),
              SettingsSwitchRow(
                icon: Icons.money_off_outlined,
                title: l10n.adminSettingsFreeMode,
                subtitle: l10n.adminSettingsFreeModeSubtitle,
                value: _draft.freeMode,
                onChanged: (value) => setState(() => _draft = _draft.copyWith(freeMode: value)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Text(l10n.adminSettingsTrialSection, style: context.typography.titleLg),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          child: SettingsSwitchRow(
            icon: Icons.hourglass_empty_rounded,
            title: l10n.adminSettingsTrialEnabled,
            subtitle: l10n.adminSettingsTrialEnabledSubtitle,
            value: _draft.trialEnabled,
            onChanged: (value) => setState(() => _draft = _draft.copyWith(trialEnabled: value)),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: l10n.adminSettingsTrialDays, controller: _trialDaysController, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sectionGap),
        Text(l10n.adminSettingsVendorSection, style: context.typography.titleLg),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          child: Column(
            children: [
              SettingsSwitchRow(
                icon: Icons.verified_outlined,
                title: l10n.adminSettingsVendorAutoVerification,
                subtitle: l10n.adminSettingsVendorAutoVerificationSubtitle,
                value: _draft.vendorAutoVerification,
                onChanged: (value) => setState(() => _draft = _draft.copyWith(vendorAutoVerification: value)),
              ),
              const Divider(height: 1),
              SettingsSwitchRow(
                icon: Icons.star_outline_rounded,
                title: l10n.adminSettingsFeaturedSearch,
                subtitle: l10n.adminSettingsFeaturedSearchSubtitle,
                value: _draft.featuredSearch,
                onChanged: (value) => setState(() => _draft = _draft.copyWith(featuredSearch: value)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Text(l10n.adminSettingsUploadSection, style: context.typography.titleLg),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(label: l10n.adminSettingsUploadMaxSizeMb, controller: _uploadMaxSizeController, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.adminSettingsUploadAllowedTypes,
          hint: l10n.adminSettingsUploadAllowedTypesHint,
          controller: _uploadTypesController,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppButton(label: l10n.adminSettingsSaveAction, loading: _saving, onPressed: _save),
      ],
    );
  }
}
