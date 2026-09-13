import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../vendors/data/vendor_models.dart';
import '../application/vendor_listing_controller.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

class VendorPackagesManageScreen extends ConsumerWidget {
  const VendorPackagesManageScreen({super.key});

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
                      l10n.vendorListingPackagesTitle,
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
                data: (listing) => _PackagesBody(packages: listing.packages, l10n: l10n),
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

class _PackagesBody extends ConsumerWidget {
  const _PackagesBody({required this.packages, required this.l10n});

  final List<PackageModel> packages;
  final AppLocalizations l10n;

  Future<void> _openForm(BuildContext context, {PackageModel? existing}) {
    return showAppBottomSheet<void>(
      context: context,
      builder: (_) => _PackageFormSheet(existing: existing, l10n: l10n),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, PackageModel package) {
    return showAppDialog<void>(
      context: context,
      title: l10n.vendorListingDeletePackageTitle,
      message: l10n.vendorListingDeletePackageMessage,
      primaryLabel: l10n.vendorListingDeleteAction,
      onPrimary: () => ref.read(vendorListingControllerProvider.notifier).deletePackage(package.id),
      secondaryLabel: l10n.searchCancel,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Positioned.fill(
          child: packages.isEmpty
              ? AppStateView(
                  icon: Icons.local_offer_outlined,
                  title: l10n.vendorListingPackagesEmptyTitle,
                  message: l10n.vendorListingPackagesEmptyMessage,
                  actionLabel: l10n.vendorListingAddPackage,
                  onAction: () => _openForm(context),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenMargin,
                    AppSpacing.sm,
                    AppSpacing.screenMargin,
                    88,
                  ),
                  itemCount: packages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final package = packages[index];
                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.lgRadius,
                        boxShadow: AppShadows.card,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(package.name, style: context.typography.titleMd),
                              ),
                              Text(
                                l10n.egpAmountLabel(_priceFormat.format(package.priceEgp)),
                                style: context.typography.price,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(package.description, style: context.typography.bodyMd),
                          if (package.inclusions.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                for (final inclusion in package.inclusions)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceBlush,
                                      borderRadius: AppRadius.fullRadius,
                                    ),
                                    child: Text(inclusion, style: context.typography.metadata),
                                  ),
                              ],
                            ),
                          ],
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => _openForm(context, existing: package),
                                icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
                              ),
                              IconButton(
                                onPressed: () => _confirmDelete(context, ref, package),
                                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        if (packages.isNotEmpty)
          PositionedDirectional(
            bottom: AppSpacing.screenMargin,
            start: AppSpacing.screenMargin,
            end: AppSpacing.screenMargin,
            child: AppButton(
              label: l10n.vendorListingAddPackage,
              icon: Icons.add_rounded,
              onPressed: () => _openForm(context),
            ),
          ),
      ],
    );
  }
}

class _PackageFormSheet extends ConsumerStatefulWidget {
  const _PackageFormSheet({required this.existing, required this.l10n});

  final PackageModel? existing;
  final AppLocalizations l10n;

  @override
  ConsumerState<_PackageFormSheet> createState() => _PackageFormSheetState();
}

class _PackageFormSheetState extends ConsumerState<_PackageFormSheet> {
  late final _nameController = TextEditingController(text: widget.existing?.name ?? '');
  late final _descriptionController = TextEditingController(text: widget.existing?.description ?? '');
  late final _priceController = TextEditingController(
    text: widget.existing != null ? widget.existing!.priceEgp.toString() : '',
  );
  late final _inclusionsController = TextEditingController(
    text: widget.existing?.inclusions.join('\n') ?? '',
  );
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _inclusionsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = int.tryParse(_priceController.text.trim()) ?? 0;
    final inclusions = _inclusionsController.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (name.isEmpty) return;

    setState(() => _saving = true);
    final package = PackageModel(
      id: widget.existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      description: description,
      priceEgp: price,
      inclusions: inclusions,
    );
    final notifier = ref.read(vendorListingControllerProvider.notifier);
    if (widget.existing != null) {
      await notifier.updatePackage(package);
    } else {
      await notifier.addPackage(package);
    }
    if (mounted) Navigator.of(context).pop();
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
              Text(
                widget.existing != null ? l10n.vendorListingEditPackage : l10n.vendorListingAddPackage,
                style: context.typography.titleLg,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.vendorListingPackageName,
                hint: l10n.vendorListingPackageNameHint,
                controller: _nameController,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.vendorListingPackageDescription,
                hint: l10n.vendorListingPackageDescriptionHint,
                controller: _descriptionController,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.vendorListingPackagePrice,
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.vendorListingPackageInclusions,
                hint: l10n.vendorListingPackageInclusionsHint,
                controller: _inclusionsController,
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: l10n.profileSaveChanges, loading: _saving, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
