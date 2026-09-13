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
import '../application/admin_subscription_plans_controller.dart';
import '../application/admin_vendor_detail_controller.dart';
import '../data/admin_models_subscription.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

class AdminVendorDetailScreen extends ConsumerWidget {
  const AdminVendorDetailScreen({super.key, required this.vendorId});

  final String vendorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(adminVendorDetailControllerProvider(vendorId));

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.screenMargin, AppSpacing.sm),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back_rounded)),
                  Expanded(
                    child: Text(l10n.adminVendorDetailTitle, style: context.typography.headlineSm, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            Expanded(
              child: detailAsync.when(
                data: (state) => _VendorDetailBody(vendorId: vendorId, state: state, l10n: l10n),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.errorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(adminVendorDetailControllerProvider(vendorId)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorDetailBody extends ConsumerWidget {
  const _VendorDetailBody({required this.vendorId, required this.state, required this.l10n});

  final String vendorId;
  final AdminVendorDetailState state;
  final AppLocalizations l10n;

  Future<void> _pickPlan(BuildContext context, WidgetRef ref) async {
    final plansAsync = ref.read(adminSubscriptionPlansControllerProvider);
    final plans = plansAsync.valueOrNull ?? const [];
    final selected = await showModalBottomSheet<AdminSubscriptionPlan>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.adminSelectPlanTitle, style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              for (final plan in plans)
                ListTile(
                  title: Text(plan.name),
                  subtitle: Text('${_priceFormat.format(plan.priceEgp)} EGP'),
                  onTap: () => Navigator.of(sheetContext).pop(plan),
                ),
            ],
          ),
        ),
      ),
    );
    if (selected == null || !context.mounted) return;
    final success = await ref.read(adminVendorDetailControllerProvider(vendorId).notifier).assignPlan(selected.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? l10n.adminPlanSavedMessage : l10n.adminGenericErrorMessage)));
    }
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref, String subscriptionId) {
    return showAppDialog<void>(
      context: context,
      title: l10n.adminVendorCancelSubscriptionTitle,
      message: l10n.adminVendorCancelSubscriptionMessage,
      primaryLabel: l10n.adminVendorCancelSubscriptionAction,
      onPrimary: () async {
        final success = await ref.read(adminVendorDetailControllerProvider(vendorId).notifier).cancelSubscription(subscriptionId);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success ? l10n.adminVendorSubscriptionCancelledMessage : l10n.adminGenericErrorMessage)),
        );
      },
      secondaryLabel: l10n.searchCancel,
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String subscriptionId) {
    return showAppDialog<void>(
      context: context,
      title: l10n.adminVendorDeleteSubscriptionTitle,
      message: l10n.adminVendorDeleteSubscriptionMessage,
      primaryLabel: l10n.adminVendorDeleteSubscriptionAction,
      onPrimary: () async {
        final success = await ref.read(adminVendorDetailControllerProvider(vendorId).notifier).deleteSubscription(subscriptionId);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success ? l10n.adminVendorSubscriptionDeletedMessage : l10n.adminGenericErrorMessage)),
        );
      },
      secondaryLabel: l10n.searchCancel,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Warm the plans list for the "assign a plan" picker.
    ref.watch(adminSubscriptionPlansControllerProvider);
    final vendor = state.vendor;
    final subscription = state.subscription;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: AppRadius.lgRadius,
              child: vendor.avatarUrl != null
                  ? AppSmartImage(path: vendor.avatarUrl!, width: 64, height: 64)
                  : Container(
                      width: 64,
                      height: 64,
                      color: AppColors.surfaceBlush,
                      alignment: Alignment.center,
                      child: const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 28),
                    ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendor.businessName, style: context.typography.headlineSm),
                  Text('${vendor.categoryName} · ${vendor.city}', style: context.typography.bodyMd),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.gold, size: 16),
                      const SizedBox(width: 3),
                      Text(vendor.rating.toStringAsFixed(1), style: context.typography.labelMd),
                      Text(' (${vendor.reviewCount})', style: context.typography.metadata),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          child: Row(
            children: [
              Icon(vendor.isVerified ? Icons.verified_rounded : Icons.verified_outlined, color: vendor.isVerified ? AppColors.gold : AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  vendor.isVerified ? l10n.adminVendorVerifiedBadge : l10n.adminVendorUnverifiedBadge,
                  style: context.typography.titleMd,
                ),
              ),
              Switch(
                value: vendor.isVerified,
                activeThumbColor: AppColors.success,
                onChanged: (value) => ref.read(adminVendorDetailControllerProvider(vendorId).notifier).setVerification(value),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Text(l10n.adminVendorContactSection, style: context.typography.titleLg),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          child: Column(
            children: [
              _InfoRow(icon: Icons.mail_outline_rounded, label: vendor.email),
              const Divider(height: AppSpacing.lg),
              _InfoRow(icon: Icons.phone_outlined, label: vendor.phone),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Text(l10n.adminVendorSubscriptionSection, style: context.typography.titleLg),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          child: subscription == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.adminVendorNoSubscription, style: context.typography.bodyMd),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(label: l10n.adminVendorAssignPlanAction, variant: AppButtonVariant.secondary, onPressed: () => _pickPlan(context, ref)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subscription.planName, style: context.typography.titleMd),
                    Text(subscription.status, style: context.typography.caption),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: l10n.adminVendorAssignPlanAction,
                            variant: AppButtonVariant.secondary,
                            onPressed: () => _pickPlan(context, ref),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppButton(
                            label: l10n.adminVendorCancelSubscriptionAction,
                            variant: AppButtonVariant.text,
                            onPressed: () => _confirmCancel(context, ref, subscription.id),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        onPressed: () => _confirmDelete(context, ref, subscription.id),
                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                        label: Text(l10n.adminVendorDeleteSubscriptionAction, style: context.typography.labelMd.copyWith(color: AppColors.error)),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(label.isEmpty ? '—' : label, style: context.typography.bodyMd)),
      ],
    );
  }
}
