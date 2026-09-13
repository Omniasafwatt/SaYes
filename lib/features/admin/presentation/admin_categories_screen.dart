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
import '../application/admin_categories_controller.dart';
import '../data/admin_models.dart';

class AdminCategoriesScreen extends ConsumerWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(adminCategoriesControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAppBottomSheet<void>(context: context, builder: (_) => _CategoryFormSheet(existing: null, l10n: l10n)),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: AppColors.textOnPrimary),
        label: Text(l10n.adminCategoryAddAction, style: context.typography.labelMd.copyWith(color: AppColors.textOnPrimary)),
      ),
      body: categoriesAsync.when(
        data: (categories) => categories.isEmpty
            ? AppStateView(
                icon: Icons.category_outlined,
                title: l10n.adminCategoriesEmptyTitle,
                message: l10n.adminCategoriesEmptyMessage,
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(adminCategoriesControllerProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.md, AppSpacing.screenMargin, 88),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) => _CategoryRow(category: categories[index], l10n: l10n),
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
          onAction: () => ref.invalidate(adminCategoriesControllerProvider),
        ),
      ),
    );
  }
}

class _CategoryRow extends ConsumerWidget {
  const _CategoryRow({required this.category, required this.l10n});

  final AdminCategoryModel category;
  final AppLocalizations l10n;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) {
    return showAppDialog<void>(
      context: context,
      title: l10n.adminCategoryDeleteTitle,
      message: l10n.adminCategoryDeleteMessage,
      primaryLabel: l10n.adminCategoryDeleteAction,
      onPrimary: () async {
        final success = await ref.read(adminCategoriesControllerProvider.notifier).delete(category.id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success ? l10n.adminCategoryDeletedMessage : l10n.adminCategoryErrorMessage)),
        );
      },
      secondaryLabel: l10n.searchCancel,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: category.isActive ? AppColors.surfaceBlush : AppColors.outlineNeutral,
              borderRadius: AppRadius.mdRadius,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.category_rounded, color: category.isActive ? AppColors.primary : AppColors.textDisabled, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name, style: context.typography.titleMd),
                if (!category.isActive)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.outlineNeutral, borderRadius: AppRadius.fullRadius),
                    child: Text(l10n.adminCategoryInactiveBadge, style: context.typography.metadata),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
            onPressed: () => showAppBottomSheet<void>(context: context, builder: (_) => _CategoryFormSheet(existing: category, l10n: l10n)),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }
}

class _CategoryFormSheet extends ConsumerStatefulWidget {
  const _CategoryFormSheet({required this.existing, required this.l10n});

  final AdminCategoryModel? existing;
  final AppLocalizations l10n;

  @override
  ConsumerState<_CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends ConsumerState<_CategoryFormSheet> {
  late final _nameController = TextEditingController(text: widget.existing?.name ?? '');
  late bool _isActive = widget.existing?.isActive ?? true;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);
    final notifier = ref.read(adminCategoriesControllerProvider.notifier);
    final success = widget.existing != null
        ? await notifier.edit(id: widget.existing!.id, name: name, isActive: _isActive)
        : await notifier.create(name: name, isActive: _isActive);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.l10n.adminCategoryErrorMessage)));
    }
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
            Text(widget.existing != null ? l10n.adminCategoryEditTitle : l10n.adminCategoryAddTitle, style: context.typography.titleLg),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: l10n.adminCategoryNameLabel, hint: l10n.adminCategoryNameHint, controller: _nameController),
            const SizedBox(height: AppSpacing.sm),
            SettingsSwitchRow(
              icon: Icons.visibility_outlined,
              title: l10n.adminCategoryActiveLabel,
              subtitle: l10n.adminCategoryActiveSubtitle,
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: l10n.adminCategorySaveAction, loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
