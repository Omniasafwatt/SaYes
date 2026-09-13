import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../categories/application/categories_controller.dart';
import '../../home/data/home_models.dart';
import '../application/vendor_listing_controller.dart';
import '../data/vendor_listing_models.dart';

class VendorBusinessDetailsScreen extends ConsumerWidget {
  const VendorBusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final listingAsync = ref.watch(vendorListingControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.screenMargin, AppSpacing.sm),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Expanded(
                    child: Text(
                      l10n.vendorListingBusinessDetailsTitle,
                      style: context.typography.headlineSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: listingAsync.when(
                data: (listing) => _BusinessDetailsForm(listing: listing, l10n: l10n),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.homeErrorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(vendorListingControllerProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessDetailsForm extends ConsumerStatefulWidget {
  const _BusinessDetailsForm({required this.listing, required this.l10n});

  final VendorListingProfile listing;
  final AppLocalizations l10n;

  @override
  ConsumerState<_BusinessDetailsForm> createState() => _BusinessDetailsFormState();
}

class _BusinessDetailsFormState extends ConsumerState<_BusinessDetailsForm> {
  late final _nameController = TextEditingController(text: widget.listing.businessName);
  late final _cityController = TextEditingController(text: widget.listing.city);
  late final _priceController = TextEditingController(text: widget.listing.startingPriceEgp.toString());
  late final _descriptionController = TextEditingController(text: widget.listing.description);
  late final _categoryId = widget.listing.categoryId;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final city = _cityController.text.trim();
    final description = _descriptionController.text.trim();
    if (name.isEmpty || city.isEmpty) return;

    setState(() => _saving = true);
    await ref.read(vendorListingControllerProvider.notifier).updateBusinessDetails(
          businessName: name,
          categoryId: _categoryId,
          city: city,
          startingPriceEgp: widget.listing.startingPriceEgp,
          description: description,
        );
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.l10n.vendorListingSavedMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final categoriesAsync = ref.watch(categoriesProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        AppTextField(label: l10n.vendorListingBusinessName, controller: _nameController),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.vendorListingCategory, style: context.typography.labelMd),
        const SizedBox(height: 8),
        categoriesAsync.when(
          data: (categories) => _CategoryDropdown(
            categories: categories,
            value: _categoryId,
            onChanged: null,
          ),
          loading: () => SkeletonBox(height: 52, borderRadius: AppRadius.fullRadius),
          error: (error, stackTrace) => const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, top: 6),
          child: Text(l10n.vendorListingCategoryLockedNote, style: context.typography.caption),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.vendorListingCity,
          hint: l10n.vendorListingCityHint,
          controller: _cityController,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.vendorListingStartingPrice,
          controller: _priceController,
          keyboardType: TextInputType.number,
          enabled: false,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, top: 6),
          child: Text(l10n.vendorListingStartingPriceNote, style: context.typography.caption),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.vendorListingDescription,
          hint: l10n.vendorListingDescriptionHint,
          controller: _descriptionController,
          maxLines: 5,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppButton(label: l10n.profileSaveChanges, loading: _saving, onPressed: _save),
      ],
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({required this.categories, required this.value, required this.onChanged});

  final List<CategoryModel> categories;
  final String value;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = categories.any((category) => category.id == value);
    final disabled = onChanged == null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: disabled ? AppColors.surfaceBlush : AppColors.surface,
        borderRadius: AppRadius.fullRadius,
        border: Border.all(color: AppColors.outlineRose),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: hasValue ? value : null,
          isExpanded: true,
          icon: disabled ? const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary, size: 18) : const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          style: context.typography.bodyLg.copyWith(color: disabled ? AppColors.textSecondary : AppColors.textPrimary),
          items: [
            for (final category in categories) DropdownMenuItem(value: category.id, child: Text(category.name)),
          ],
          onChanged: disabled
              ? null
              : (selected) {
                  if (selected != null) onChanged!(selected);
                },
        ),
      ),
    );
  }
}
