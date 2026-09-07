import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../application/notifications_controller.dart';

/// Bell icon used on both the customer Home header and the vendor
/// Dashboard header. Self-contained: watches its own unread count and
/// navigates to the Notifications screen on tap, so both call sites just
/// drop in `const NotificationBell()`.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnread = ref.watch(notificationsControllerProvider).value?.any((n) => !n.read) ?? false;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.notifications),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, boxShadow: AppShadows.card),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 20),
            if (hasUnread)
              PositionedDirectional(
                top: 9,
                end: 10,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
