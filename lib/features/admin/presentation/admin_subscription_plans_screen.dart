import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/presentation/widgets/account_widgets.dart';
import '../application/admin_subscription_plans_controller.dart';
import '../data/admin_models_subscription.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

class AdminSubscriptionPlansScreen extends ConsumerWidget {
  const AdminSubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plansAsync = ref.watch(adminSubscriptionPlansControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAppBottomSheet<void>(context: context, builder: (_) => _PlanFormSheet(existing: null, l10n: l10n)),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: AppColors.textOnPrimary),
        label: Text(l10n.adminPlanAddAction, style: context.typography.labelMd.copyWith(color: AppColors.textOnPrimary)),
      ),
      body: plansAsync.when(
        data: (plans) => plans.isEmpty
            ? AppStateView(icon: Icons.workspace_premium_outlined, title: l10n.adminPlansEmptyTitle, message: l10n.adminPlansEmptyMessage)
            : RefreshIndicator(
                onRefresh: () => ref.refresh(adminSubscriptionPlansControllerProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.md, AppSpacing.screenMargin, 88),
                  itemCount: plans.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) => _PlanCard(plan: plans[index], l10n: l10n),
                ),
              ),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (error, stackTrace) => AppStateView(
          icon: Icons.wifi_off_rounded,
          title: l10n.errorTitle,
          message: l10n.errorMessage,
          actionLabel: l10n.errorAction,
          iconColor: AppColors.error,
          iconBackground: AppColors.errorContainer,
          onAction: () => ref.invalidate(adminSubscriptionPlansControllerProvider),
        ),
      ),
    );
  }
}

class _PlanCard extends ConsumerWidget {
  const _PlanCard({required this.plan, required this.l10n});

  final AdminSubscriptionPlan plan;
  final AppLocalizations l10n;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) {
    return showAppDialog<void>(
      context: context,
      title: l10n.adminPlanDeleteTitle,
      message: l10n.adminPlanDeleteMessage,
      primaryLabel: l10n.adminPlanDeleteAction,
      onPrimary: () async {
        final success = await ref.read(adminSubscriptionPlansControllerProvider.notifier).delete(plan.id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? l10n.adminPlanDeletedMessage : l10n.adminPlanErrorMessage)));
      },
      secondaryLabel: l10n.searchCancel,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.card,
        border: plan.isFeatured ? Border.all(color: AppColors.gold, width: 1.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(plan.name, style: context.typography.titleLg)),
              if (plan.isFeatured) const Padding(padding: EdgeInsetsDirectional.only(end: 6), child: Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 20)),
              if (!plan.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.outlineNeutral, borderRadius: AppRadius.fullRadius),
                  child: Text(l10n.adminPlanInactiveBadge, style: context.typography.metadata),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(plan.description, style: context.typography.bodyMd),
          const SizedBox(height: AppSpacing.sm),
          Text(
            plan.priceEgp == 0 ? l10n.adminSettingsFreeMode : '${_priceFormat.format(plan.priceEgp)} EGP / month',
            style: context.typography.price,
          ),
          const SizedBox(height: 4),
          Text(
            '${plan.maxPackages?.toString() ?? '∞'} packages · ${plan.maxPortfolioItems?.toString() ?? '∞'} photos · priority ${plan.priorityScore}',
            style: context.typography.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
                onPressed: () => showAppBottomSheet<void>(context: context, builder: (_) => _PlanFormSheet(existing: plan, l10n: l10n)),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                onPressed: () => _confirmDelete(context, ref),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => ref.read(adminSubscriptionPlansControllerProvider.notifier).setActive(plan.id, !plan.isActive),
                child: Text(plan.isActive ? l10n.adminPlanDeactivateAction : l10n.adminPlanActivateAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanFormSheet extends ConsumerStatefulWidget {
  const _PlanFormSheet({required this.existing, required this.l10n});

  final AdminSubscriptionPlan? existing;
  final AppLocalizations l10n;

  @override
  ConsumerState<_PlanFormSheet> createState() => _PlanFormSheetState();
}

class _PlanFormSheetState extends ConsumerState<_PlanFormSheet> {
  late final _nameController = TextEditingController(text: widget.existing?.name ?? '');
  late final _descriptionController = TextEditingController(text: widget.existing?.description ?? '');
  late final _priceController = TextEditingController(text: widget.existing != null ? widget.existing!.priceEgp.toString() : '0');
  late final _priorityController = TextEditingController(text: widget.existing?.priorityScore.toString() ?? '0');
  late final _maxPackagesController = TextEditingController(text: widget.existing?.maxPackages?.toString() ?? '');
  late final _maxPortfolioController = TextEditingController(text: widget.existing?.maxPortfolioItems?.toString() ?? '');
  late bool _isFeatured = widget.existing?.isFeatured ?? false;
  late bool _isActive = widget.existing?.isActive ?? true;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _priorityController.dispose();
    _maxPackagesController.dispose();
    _maxPortfolioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);
    final notifier = ref.read(adminSubscriptionPlansControllerProvider.notifier);
    final maxPackages = int.tryParse(_maxPackagesController.text.trim());
    final maxPortfolioItems = int.tryParse(_maxPortfolioController.text.trim());
    final success = widget.existing != null
        ? await notifier.edit(
            id: widget.existing!.id,
            name: name,
            description: description,
            priceEgp: int.tryParse(_priceController.text.trim()) ?? widget.existing!.priceEgp,
            maxPackages: maxPackages,
            maxPortfolioItems: maxPortfolioItems,
            isFeatured: _isFeatured,
          )
        : await notifier.create(
            name: name,
            description: description,
            priceEgp: int.tryParse(_priceController.text.trim()) ?? 0,
            interval: 'MONTHLY',
            priorityScore: int.tryParse(_priorityController.text.trim()) ?? 0,
            maxPackages: maxPackages,
            maxPortfolioItems: maxPortfolioItems,
            isFeatured: _isFeatured,
            isActive: _isActive,
          );
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.l10n.adminPlanErrorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.sm, AppSpacing.screenMargin, AppSpacing.lg),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.existing != null ? l10n.adminPlanEditTitle : l10n.adminPlanAddTitle, style: context.typography.titleLg),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: l10n.adminPlanNameLabel, controller: _nameController),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: l10n.adminPlanDescriptionLabel, controller: _descriptionController, maxLines: 2),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: l10n.adminPlanPriceLabel, controller: _priceController, keyboardType: TextInputType.number),
              if (widget.existing == null) ...[
                const SizedBox(height: AppSpacing.md),
                AppTextField(label: l10n.adminPlanPriorityLabel, controller: _priorityController, keyboardType: TextInputType.number),
              ],
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: l10n.adminPlanMaxPackagesLabel, controller: _maxPackagesController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: l10n.adminPlanMaxPortfolioLabel, controller: _maxPortfolioController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              SettingsSwitchRow(
                icon: Icons.workspace_premium_outlined,
                title: l10n.adminPlanFeaturedLabel,
                subtitle: l10n.adminPlanFeaturedSubtitle,
                value: _isFeatured,
                onChanged: (value) => setState(() => _isFeatured = value),
              ),
              if (widget.existing == null)
                SettingsSwitchRow(
                  icon: Icons.visibility_outlined,
                  title: l10n.adminPlanActiveLabel,
                  subtitle: l10n.adminPlanActiveSubtitle,
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: l10n.adminPlanSaveAction, loading: _saving, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
