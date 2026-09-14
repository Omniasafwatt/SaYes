import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/notifications_controller.dart';
import '../data/notification_item.dart';

/// The signed-in account's notification inbox — reached from the bell icon
/// on the customer Home or vendor Dashboard header. Content is derived live
/// from the account's own real bookings (see [ApiNotificationsRepository]);
/// tapping an item marks it read.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notificationsAsync = ref.watch(notificationsControllerProvider);
    final hasUnread = notificationsAsync.value?.any((n) => !n.read) ?? false;

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
                    child: Text(l10n.notificationsTitle, style: context.typography.headlineSm),
                  ),
                  if (hasUnread)
                    TextButton(
                      onPressed: () => ref.read(notificationsControllerProvider.notifier).markAllAsRead(),
                      child: Text(l10n.notificationsMarkAllRead),
                    ),
                ],
              ),
            ),
            Expanded(
              child: notificationsAsync.when(
                data: (notifications) => notifications.isEmpty
                    ? AppStateView(
                        icon: Icons.notifications_none_rounded,
                        title: l10n.notificationsEmptyTitle,
                        message: l10n.notificationsEmptyMessage,
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () => ref.read(notificationsControllerProvider.notifier).refresh(),
                        child: _NotificationsList(notifications: notifications),
                      ),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.errorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.read(notificationsControllerProvider.notifier).refresh(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  const _NotificationsList({required this.notifications});

  final List<NotificationItem> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.sm,
        AppSpacing.screenMargin,
        AppSpacing.sectionGap,
      ),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final item = notifications[index];
        return FadeSlideIn(
          delay: Duration(milliseconds: 30 * index.clamp(0, 6)),
          child: _NotificationCard(item: item),
        );
      },
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.item});

  final NotificationItem item;

  static const _kindStyle = {
    NotificationKind.requestSent: (icon: Icons.send_rounded, color: AppColors.primary),
    NotificationKind.requestAccepted: (icon: Icons.check_circle_rounded, color: AppColors.success),
    NotificationKind.requestRejected: (icon: Icons.cancel_rounded, color: AppColors.error),
    NotificationKind.incomingRequest: (icon: Icons.notifications_active_rounded, color: AppColors.primary),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.typography;
    final style = _kindStyle[item.kind]!;

    return InkWell(
      borderRadius: AppRadius.lgRadius,
      onTap: item.read ? null : () => ref.read(notificationsControllerProvider.notifier).markAsRead(item.id),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          color: item.read ? AppColors.surface : AppColors.surfaceBlush,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: AppColors.outlineNeutral),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: style.color.withValues(alpha: 0.12), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(style.icon, size: 18, color: style.color),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: t.titleMd),
                  const SizedBox(height: 2),
                  Text(item.body, style: t.bodyMd),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(item.createdAt),
                    style: t.caption,
                  ),
                ],
              ),
            ),
            if (!item.read) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(color: style.color, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
