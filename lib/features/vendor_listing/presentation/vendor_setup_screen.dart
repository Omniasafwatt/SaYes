import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../categories/application/categories_controller.dart';
import '../../home/data/home_models.dart';
import '../data/vendor_listing_repository.dart';

/// A one-time gate shown to a signed-in vendor account that has no
/// `/vendors` record yet (`GET /vendors/me` returns 404) — a brand-new
/// vendor sign-up has auth credentials but no listing until this runs.
/// Category can only ever be chosen here: the update endpoint never
/// accepts it again afterward (see `VendorBusinessDetailsScreen`).
class VendorSetupScreen extends ConsumerStatefulWidget {
  const VendorSetupScreen({super.key});

  @override
  ConsumerState<VendorSetupScreen> createState() => _VendorSetupScreenState();
}

class _VendorSetupScreenState extends ConsumerState<VendorSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();
  String? _categoryId;
  bool _saving = false;
  bool _categoryTouched = false;

  @override
  void dispose() {
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    setState(() => _categoryTouched = true);
    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid || _categoryId == null) return;

    setState(() => _saving = true);
    try {
      await ref.read(vendorListingRepositoryProvider).createProfile(
            categoryId: _categoryId!,
            city: _cityController.text.trim(),
            bio: _bioController.text.trim(),
          );
      if (!mounted) return;
      context.go(AppRoutes.vendorHome);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.vendorSetupError)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenMargin),
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.vendorSetupTitle, style: context.typography.headlineLg),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.vendorSetupSubtitle, style: context.typography.bodyMd.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.vendorListingCategory, style: context.typography.labelMd),
              const SizedBox(height: 8),
              categoriesAsync.when(
                data: (categories) => _CategoryPicker(
                  categories: categories,
                  value: _categoryId,
                  hint: l10n.vendorSetupCategoryHint,
                  onChanged: (value) => setState(() => _categoryId = value),
                ),
                loading: () => SkeletonBox(height: 52, borderRadius: AppRadius.fullRadius),
                error: (error, stackTrace) => const SizedBox.shrink(),
              ),
              if (_categoryTouched && _categoryId == null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 4, top: 6),
                  child: Text(l10n.vendorSetupCategoryRequired, style: context.typography.caption.copyWith(color: AppColors.error)),
                ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.vendorSetupCity,
                hint: l10n.vendorSetupCityHint,
                controller: _cityController,
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.vendorSetupCityHint : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.vendorSetupBio,
                hint: l10n.vendorSetupBioHint,
                controller: _bioController,
                maxLines: 5,
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.vendorSetupBioHint : null,
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              AppButton(label: l10n.vendorSetupSubmit, loading: _saving, onPressed: () => _submit(l10n)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({required this.categories, required this.value, required this.hint, required this.onChanged});

  final List<CategoryModel> categories;
  final String? value;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = categories.any((category) => category.id == value);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.fullRadius,
        border: Border.all(color: AppColors.outlineRose),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: hasValue ? value : null,
          hint: Text(hint, style: context.typography.bodyLg.copyWith(color: AppColors.textSecondary)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          style: context.typography.bodyLg.copyWith(color: AppColors.textPrimary),
          items: [
            for (final category in categories) DropdownMenuItem(value: category.id, child: Text(category.name)),
          ],
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
      ),
    );
  }
}
