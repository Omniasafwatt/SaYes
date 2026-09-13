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
import '../../categories/application/categories_controller.dart';
import '../application/admin_moderation_controllers.dart';
import '../data/admin_models.dart';

class AdminVendorsScreen extends ConsumerStatefulWidget {
  const AdminVendorsScreen({super.key});

  @override
  ConsumerState<AdminVendorsScreen> createState() => _AdminVendorsScreenState();
}

class _AdminVendorsScreenState extends ConsumerState<AdminVendorsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 300) {
      ref.read(adminVendorsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adminVendorsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.md, AppSpacing.screenMargin, AppSpacing.sm),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: OutlinedButton.icon(
                onPressed: () => showAppBottomSheet<void>(context: context, builder: (_) => _VendorFilterSheet(l10n: l10n)),
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: Text(l10n.adminVendorsFilterTitle),
              ),
            ),
          ),
          Expanded(
            child: switch (state.status) {
              AdminListStatus.loading => const Center(child: AppLoadingIndicator()),
              AdminListStatus.error => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.errorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.read(adminVendorsControllerProvider.notifier).retry(),
                ),
              AdminListStatus.empty => AppStateView(
                  icon: Icons.storefront_outlined,
                  title: l10n.adminVendorsEmptyTitle,
                  message: l10n.adminVendorsEmptyMessage,
                ),
              AdminListStatus.success || AdminListStatus.loadingMore => RefreshIndicator(
                  onRefresh: () => ref.read(adminVendorsControllerProvider.notifier).retry(),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, 0, AppSpacing.screenMargin, AppSpacing.sectionGap),
                    itemCount: state.vendors.length + (state.status == AdminListStatus.loadingMore ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      if (index >= state.vendors.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                          child: Center(child: AppLoadingIndicator(size: 24)),
                        );
                      }
                      final vendor = state.vendors[index];
                      return _VendorRow(vendor: vendor, l10n: l10n);
                    },
                  ),
                ),
            },
          ),
        ],
      ),
    );
  }
}

class _VendorRow extends ConsumerWidget {
  const _VendorRow({required this.vendor, required this.l10n});

  final AdminVendorSummary vendor;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.lgRadius,
      child: InkWell(
        borderRadius: AppRadius.lgRadius,
        onTap: () => context.push(AppRoutes.adminVendorDetail, extra: vendor.id),
        child: Container(
          decoration: BoxDecoration(borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.mdRadius,
                child: vendor.avatarUrl != null
                    ? AppSmartImage(path: vendor.avatarUrl!, width: 48, height: 48)
                    : Container(
                        width: 48,
                        height: 48,
                        color: AppColors.surfaceBlush,
                        alignment: Alignment.center,
                        child: const Icon(Icons.storefront_rounded, color: AppColors.primary),
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vendor.businessName, style: context.typography.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${vendor.categoryName} · ${vendor.city}', style: context.typography.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Switch(
                value: vendor.isVerified,
                activeThumbColor: AppColors.success,
                onChanged: (value) => ref.read(adminVendorsControllerProvider.notifier).setVerification(vendor.id, value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VendorFilterSheet extends ConsumerStatefulWidget {
  const _VendorFilterSheet({required this.l10n});
  final AppLocalizations l10n;

  @override
  ConsumerState<_VendorFilterSheet> createState() => _VendorFilterSheetState();
}

class _VendorFilterSheetState extends ConsumerState<_VendorFilterSheet> {
  late String? _categoryId = ref.read(adminVendorsControllerProvider).filters.categoryId;
  late final _cityController = TextEditingController(text: ref.read(adminVendorsControllerProvider).filters.city ?? '');
  late bool? _verifiedOnly = ref.read(adminVendorsControllerProvider).filters.verifiedOnly;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final categoriesAsync = ref.watch(categoriesProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.sm, AppSpacing.screenMargin, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.adminVendorsFilterTitle, style: context.typography.titleLg),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.adminVendorsFilterCategory, style: context.typography.labelMd),
            const SizedBox(height: 8),
            categoriesAsync.when(
              data: (categories) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.adminVendorsFilterAll),
                    selected: _categoryId == null,
                    onSelected: (_) => setState(() => _categoryId = null),
                  ),
                  for (final category in categories)
                    ChoiceChip(
                      label: Text(category.name),
                      selected: _categoryId == category.id,
                      onSelected: (_) => setState(() => _categoryId = category.id),
                    ),
                ],
              ),
              loading: () => SkeletonBox(height: 36, borderRadius: AppRadius.fullRadius),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: l10n.adminVendorsFilterCity, hint: l10n.adminVendorsFilterCityHint, controller: _cityController),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.verified_outlined, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(l10n.adminVendorsFilterVerifiedOnly, style: context.typography.bodyLg)),
                Switch(
                  value: _verifiedOnly ?? false,
                  activeThumbColor: AppColors.primary,
                  onChanged: (value) => setState(() => _verifiedOnly = value ? true : null),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.adminVendorsApplyFilters,
              onPressed: () {
                ref.read(adminVendorsControllerProvider.notifier).setFilters(AdminVendorFilters(
                      categoryId: _categoryId,
                      city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
                      verifiedOnly: _verifiedOnly,
                    ));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
