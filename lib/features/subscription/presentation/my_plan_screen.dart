import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/subscription_controller.dart';
import '../data/subscription_models.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// The vendor's own current plan and its renewal date, with an entry point
/// into the full plan comparison. Reachable from Vendor Profile's
/// "Subscription" row.
class MyPlanScreen extends ConsumerWidget {
  const MyPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subscriptionAsync = ref.watch(mySubscriptionProvider);

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
                      l10n.subscriptionMyPlanTitle,
                      style: context.typography.headlineSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: subscriptionAsync.when(
                data: (subscription) => _MyPlanBody(subscription: subscription, l10n: l10n),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.errorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(mySubscriptionProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPlanBody extends ConsumerWidget {
  const _MyPlanBody({required this.subscription, required this.l10n});

  final VendorSubscription subscription;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(mySubscriptionHistoryProvider);
    final plan = subscription.plan;
    final trialLabel =
        subscription.isTrialing ? l10n.subscriptionTrialDaysRemaining(subscription.trialDaysRemaining) : null;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.gold]),
            borderRadius: AppRadius.xlRadius,
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: AppRadius.fullRadius,
                ),
                child: Text(
                  l10n.subscriptionCurrentPlanBadge,
                  style: context.typography.labelSm.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(plan.name, style: context.typography.headlineLg.copyWith(color: Colors.white)),
              const SizedBox(height: 4),
              Text(
                plan.priceEgp == 0
                    ? plan.description
                    : '${l10n.egpAmountLabel(_priceFormat.format(plan.priceEgp))} ${plan.interval == 'YEARLY' ? l10n.subscriptionYearly : l10n.subscriptionMonthly}',
                style: context.typography.bodyLg.copyWith(color: Colors.white.withValues(alpha: 0.9)),
              ),
              if (trialLabel != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(trialLabel, style: context.typography.caption.copyWith(color: Colors.white.withValues(alpha: 0.85))),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          child: Column(
            children: [
              _LimitRow(
                icon: Icons.local_offer_outlined,
                label: subscription.maxPackages == null
                    ? l10n.subscriptionUnlimited
                    : l10n.subscriptionMaxPackages(subscription.maxPackages.toString()),
              ),
              const Divider(height: AppSpacing.lg),
              _LimitRow(
                icon: Icons.photo_library_outlined,
                label: subscription.maxPortfolioItems == null
                    ? l10n.subscriptionUnlimited
                    : l10n.subscriptionMaxPortfolioItems(subscription.maxPortfolioItems.toString()),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppButton(
          label: l10n.subscriptionComparePlans,
          icon: Icons.workspace_premium_outlined,
          onPressed: () => context.push(AppRoutes.subscriptionPlans),
        ),
        historyAsync.maybeWhen(
          data: (history) => history.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sectionGap),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.subscriptionHistoryTitle, style: context.typography.titleLg),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
                        child: Column(
                          children: [
                            for (final (index, entry) in history.indexed) ...[
                              if (index > 0) const Divider(height: 1),
                              _HistoryRow(entry: entry),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});
  final SubscriptionHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    final range = entry.startedAt == null
        ? ''
        : entry.currentPeriodEnd == null
            ? dateFormat.format(entry.startedAt!)
            : '${dateFormat.format(entry.startedAt!)} – ${dateFormat.format(entry.currentPeriodEnd!)}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.planName, style: context.typography.titleMd),
                if (range.isNotEmpty) Text(range, style: context.typography.caption),
              ],
            ),
          ),
          Text(entry.status, style: context.typography.labelSm),
        ],
      ),
    );
  }
}

class _LimitRow extends StatelessWidget {
  const _LimitRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: context.typography.bodyMd),
      ],
    );
  }
}
