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
import '../application/subscription_controller.dart';
import '../data/subscription_models.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// Every active plan, with a "switch to this plan" action on each — reached
/// from My Plan. Switching is applied immediately by the API.
class ComparePlansScreen extends ConsumerWidget {
  const ComparePlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plansAsync = ref.watch(activePlansProvider);
    final currentAsync = ref.watch(mySubscriptionProvider);

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
                      l10n.subscriptionPlansTitle,
                      style: context.typography.headlineSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: plansAsync.when(
                data: (plans) => _PlansList(plans: plans, currentPlanId: currentAsync.valueOrNull?.plan.id, l10n: l10n),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.errorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(activePlansProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlansList extends ConsumerWidget {
  const _PlansList({required this.plans, required this.currentPlanId, required this.l10n});

  final List<SubscriptionPlan> plans;
  final String? currentPlanId;
  final AppLocalizations l10n;

  Future<void> _confirmSwitch(BuildContext context, WidgetRef ref, SubscriptionPlan plan) {
    return showAppDialog<void>(
      context: context,
      title: l10n.subscriptionSwitchConfirmTitle,
      message: l10n.subscriptionSwitchConfirmMessage,
      primaryLabel: l10n.subscriptionSwitchAction,
      onPrimary: () async {
        final success = await ref.read(subscriptionSwitchControllerProvider.notifier).switchPlan(plan.id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success ? l10n.subscriptionSwitchSuccess : l10n.subscriptionSwitchError)),
        );
      },
      secondaryLabel: l10n.searchCancel,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final switching = ref.watch(subscriptionSwitchControllerProvider).isLoading;

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenMargin),
      itemCount: plans.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final plan = plans[index];
        final isCurrent = plan.id == currentPlanId;
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
                  if (plan.isFeatured)
                    const Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 20),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                plan.priceEgp == 0
                    ? plan.description
                    : '${l10n.egpAmountLabel(_priceFormat.format(plan.priceEgp))} ${plan.interval == 'YEARLY' ? l10n.subscriptionYearly : l10n.subscriptionMonthly}',
                style: context.typography.bodyMd.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                plan.maxPackages == null ? l10n.subscriptionUnlimited : l10n.subscriptionMaxPackages(plan.maxPackages.toString()),
                style: context.typography.bodyMd,
              ),
              const SizedBox(height: 4),
              Text(
                plan.maxPortfolioItems == null
                    ? l10n.subscriptionUnlimited
                    : l10n.subscriptionMaxPortfolioItems(plan.maxPortfolioItems.toString()),
                style: context.typography.bodyMd,
              ),
              const SizedBox(height: AppSpacing.md),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.surfaceBlush, borderRadius: AppRadius.fullRadius),
                  child: Text(l10n.subscriptionCurrentPlanBadge, style: context.typography.labelMd),
                )
              else
                AppButton(
                  label: l10n.subscriptionSwitchAction,
                  variant: AppButtonVariant.secondary,
                  loading: switching,
                  onPressed: () => _confirmSwitch(context, ref, plan),
                ),
            ],
          ),
        );
      },
    );
  }
}
