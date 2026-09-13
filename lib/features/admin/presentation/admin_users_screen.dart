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
import '../application/admin_moderation_controllers.dart';
import '../data/admin_models.dart';
import 'admin_labels.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 300) {
      ref.read(adminUsersControllerProvider.notifier).loadMore();
    }
  }

  void _submitSearch(AdminUsersState current) {
    final search = _searchController.text.trim();
    ref.read(adminUsersControllerProvider.notifier).setFilters(AdminUserFilters(
          role: current.filters.role,
          isActive: current.filters.isActive,
          search: search.isEmpty ? null : search,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adminUsersControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.md, AppSpacing.screenMargin, AppSpacing.sm),
            child: AppTextField(
              hint: l10n.adminUsersSearchHint,
              controller: _searchController,
              prefixIcon: Icons.search_rounded,
              onChanged: (_) => _submitSearch(state),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
            child: Wrap(
              spacing: 8,
              children: [
                for (final role in [null, ...AdminUserRole.values])
                  ChoiceChip(
                    label: Text(role == null ? l10n.adminVendorsFilterAll : roleLabelForAdmin(l10n,role)),
                    selected: state.filters.role == role,
                    onSelected: (_) => ref.read(adminUsersControllerProvider.notifier).setFilters(
                          AdminUserFilters(role: role, isActive: state.filters.isActive, search: state.filters.search),
                        ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
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
                  onAction: () => ref.read(adminUsersControllerProvider.notifier).retry(),
                ),
              AdminListStatus.empty => AppStateView(icon: Icons.group_outlined, title: l10n.adminUsersEmptyTitle, message: l10n.adminUsersEmptyMessage),
              AdminListStatus.success || AdminListStatus.loadingMore => RefreshIndicator(
                  onRefresh: () => ref.read(adminUsersControllerProvider.notifier).retry(),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, 0, AppSpacing.screenMargin, AppSpacing.sectionGap),
                    itemCount: state.users.length + (state.status == AdminListStatus.loadingMore ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      if (index >= state.users.length) {
                        return const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.lg), child: Center(child: AppLoadingIndicator(size: 24)));
                      }
                      final user = state.users[index];
                      return _UserRow(user: user, l10n: l10n);
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

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user, required this.l10n});

  final AdminUserSummary user;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.lgRadius,
      child: InkWell(
        borderRadius: AppRadius.lgRadius,
        onTap: () => context.push(AppRoutes.adminUserDetail, extra: user.id),
        child: Container(
          decoration: BoxDecoration(borderRadius: AppRadius.lgRadius, boxShadow: AppShadows.card),
          padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(user.name, style: context.typography.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        if (!user.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.errorContainer, borderRadius: AppRadius.fullRadius),
                            child: Text(l10n.adminUserActiveLabel, style: context.typography.metadata.copyWith(color: AppColors.onErrorContainer)),
                          ),
                      ],
                    ),
                    Text(user.email, style: context.typography.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceBlush, borderRadius: AppRadius.fullRadius),
                child: Text(roleLabelForAdmin(l10n,user.role), style: context.typography.labelSm),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
