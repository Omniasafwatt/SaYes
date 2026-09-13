import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/admin_user_detail_controller.dart';
import '../data/admin_models.dart';
import 'admin_labels.dart';

class AdminUserDetailScreen extends ConsumerWidget {
  const AdminUserDetailScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(adminUserDetailControllerProvider(userId));

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
                    child: Text(l10n.adminUserDetailTitle, style: context.typography.headlineSm, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            Expanded(
              child: userAsync.when(
                data: (user) => _UserDetailBody(userId: userId, user: user, l10n: l10n),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.errorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(adminUserDetailControllerProvider(userId)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserDetailBody extends ConsumerWidget {
  const _UserDetailBody({required this.userId, required this.user, required this.l10n});

  final String userId;
  final AdminUserSummary user;
  final AppLocalizations l10n;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 ? parts.last[0] : '';
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(color: AppColors.surfaceBlush, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(_initials(user.name), style: context.typography.titleLg.copyWith(color: AppColors.primary)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: context.typography.titleLg),
                  Text(user.email, style: context.typography.bodyMd),
                  if (user.phone.isNotEmpty) Text(user.phone, style: context.typography.caption),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Text(l10n.adminUserRoleLabel, style: context.typography.titleLg),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.fullRadius, boxShadow: AppShadows.card),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AdminUserRole>(
              value: user.role,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
              items: [
                for (final role in AdminUserRole.values)
                  DropdownMenuItem(value: role, child: Text(roleLabelForAdmin(l10n, role))),
              ],
              onChanged: (role) async {
                if (role == null) return;
                await ref.read(adminUserDetailControllerProvider(userId).notifier).setRole(role);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.adminUserRoleChangedMessage)));
                }
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          child: Row(
            children: [
              const Icon(Icons.toggle_on_outlined, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.adminUserActiveLabel, style: context.typography.titleMd),
                    Text(l10n.adminUserActiveSubtitle, style: context.typography.caption),
                  ],
                ),
              ),
              Switch(
                value: user.isActive,
                activeThumbColor: AppColors.success,
                onChanged: (value) => ref.read(adminUserDetailControllerProvider(userId).notifier).setActive(value),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
