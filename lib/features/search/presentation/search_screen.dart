import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/animations/pressable_scale.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../categories/application/categories_controller.dart';
import '../../favorites/application/favorites_controller.dart';
import '../../vendors/application/vendor_filters_controller.dart';
import '../../vendors/presentation/filter_bottom_sheet.dart';
import '../application/search_controller.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// Full search experience: input, category suggestions, locally persisted
/// recent searches, paginated results (never the whole vendor list at
/// once), and dedicated loading/empty/error states for each phase of the
/// flow. Pushed full-screen from Home's search bar.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 300) {
      ref.read(searchControllerProvider.notifier).loadMore();
    }
  }

  void _submit(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    ref.read(searchControllerProvider.notifier).search(value);
    _focusNode.unfocus();
  }

  Future<void> _openFilters() async {
    _focusNode.unfocus();
    final current = ref.read(vendorFiltersProvider);
    await showAppBottomSheet<void>(
      context: context,
      builder: (_) => FilterBottomSheet(
        initialFilters: current,
        onApply: (filters) => ref.read(vendorFiltersProvider.notifier).set(filters),
      ),
    );
    ref.read(searchControllerProvider.notifier).applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(searchControllerProvider);
    final favorites = ref.watch(favoritesControllerProvider);
    final filtersActive = !ref.watch(vendorFiltersProvider).isDefault;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenMargin, AppSpacing.sm, AppSpacing.screenMargin, AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.fullRadius,
                        border: Border.all(color: AppColors.outlineRose),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              textInputAction: TextInputAction.search,
                              style: context.typography.bodyLg,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: l10n.homeSearchHint,
                                hintStyle: context.typography.bodyLg.copyWith(color: AppColors.textSecondary),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onSubmitted: _submit,
                            ),
                          ),
                          if (_controller.text.isNotEmpty)
                            PressableScale(
                              onTap: () {
                                _controller.clear();
                                ref.read(searchControllerProvider.notifier).clearQuery();
                                setState(() {});
                              },
                              child: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 18),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: _openFilters,
                        icon: const Icon(Icons.tune_rounded, color: AppColors.textPrimary),
                        tooltip: l10n.filtersButtonLabel,
                      ),
                      if (filtersActive)
                        PositionedDirectional(
                          top: 6,
                          end: 6,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          ),
                        ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text(l10n.searchCancel),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
              child: Align(alignment: AlignmentDirectional.centerEnd, child: LanguageSwitcher()),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: switch (state.status) {
                SearchStatus.empty => _SearchIdleView(
                    l10n: l10n,
                    recentSearches: state.recentSearches,
                    onTapSuggestion: _submit,
                    onRemoveRecent: (q) => ref.read(searchControllerProvider.notifier).removeRecent(q),
                    onClearRecent: () => ref.read(searchControllerProvider.notifier).clearRecent(),
                  ),
                SearchStatus.loading => const _SearchLoadingSkeleton(),
                SearchStatus.error => AppStateView(
                    icon: Icons.wifi_off_rounded,
                    title: l10n.errorTitle,
                    message: l10n.searchErrorMessage,
                    actionLabel: l10n.errorAction,
                    iconColor: AppColors.error,
                    iconBackground: AppColors.errorContainer,
                    onAction: () => ref.read(searchControllerProvider.notifier).search(state.query),
                  ),
                SearchStatus.noResults => AppStateView(
                    icon: Icons.search_off_rounded,
                    title: l10n.searchNoResultsTitle,
                    message: l10n.searchNoResultsMessage(state.query),
                  ),
                SearchStatus.success || SearchStatus.loadingMore => _SearchResultsList(
                    scrollController: _scrollController,
                    state: state,
                    favoriteIds: favorites,
                    l10n: l10n,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchIdleView extends ConsumerWidget {
  const _SearchIdleView({
    required this.l10n,
    required this.recentSearches,
    required this.onTapSuggestion,
    required this.onRemoveRecent,
    required this.onClearRecent,
  });

  final AppLocalizations l10n;
  final List<String> recentSearches;
  final ValueChanged<String> onTapSuggestion;
  final ValueChanged<String> onRemoveRecent;
  final VoidCallback onClearRecent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.md),
      children: [
        if (recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.searchRecentTitle, style: context.typography.titleMd),
              TextButton(onPressed: onClearRecent, child: Text(l10n.searchClearAll)),
            ],
          ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final query in recentSearches)
                InputChip(
                  label: Text(query),
                  labelStyle: context.typography.labelMd,
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.outlineRose),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.fullRadius),
                  onPressed: () => onTapSuggestion(query),
                  onDeleted: () => onRemoveRecent(query),
                  deleteIconColor: AppColors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: AppStateView(
              icon: Icons.travel_explore_rounded,
              title: l10n.searchEmptyPromptTitle,
              message: l10n.searchEmptyPromptMessage,
            ),
          ),
        ],
        Text(l10n.searchSuggestionsTitle, style: context.typography.titleMd),
        const SizedBox(height: AppSpacing.sm),
        categoriesAsync.when(
          data: (categories) => Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final category in categories)
                AppChip(label: category.name, selected: false, icon: category.icon, onTap: () => onTapSuggestion(category.name)),
            ],
          ),
          loading: () => const SizedBox(height: 40),
          error: (error, stackTrace) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    required this.scrollController,
    required this.state,
    required this.favoriteIds,
    required this.l10n,
  });

  final ScrollController scrollController;
  final SearchState state;
  final Set<String> favoriteIds;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.sizeOf(context).width - (AppSpacing.screenMargin * 2);

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.sm,
        AppSpacing.screenMargin,
        AppSpacing.sectionGap,
      ),
      itemCount: state.results.length + 2,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(l10n.searchResultsCount(state.results.length), style: context.typography.metadata),
          );
        }
        final vendorIndex = index - 1;
        if (vendorIndex >= state.results.length) {
          return state.status == SearchStatus.loadingMore
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(child: AppLoadingIndicator(size: 24)),
                )
              : const SizedBox.shrink();
        }
        final vendor = state.results[vendorIndex];
        return FadeSlideIn(
          delay: Duration(milliseconds: 30 * vendorIndex.clamp(0, 6)),
          child: Consumer(
            builder: (context, ref, _) {
              final isFavorite = favoriteIds.contains(vendor.id);
              return VendorCard(
                imageUrl: vendor.imageAsset,
                isAssetImage: true,
                name: vendor.name,
                city: vendor.city,
                rating: vendor.rating,
                reviewCountLabel: l10n.vendorReviewCount(vendor.reviewCount),
                startingPriceLabel: l10n.vendorStartingFrom(_priceFormat.format(vendor.startingPriceEgp)),
                isVerified: vendor.isVerified,
                verifiedLabel: l10n.verifiedLabel,
                isFeatured: vendor.isFeatured,
                featuredLabel: l10n.featuredLabel,
                isFavorite: isFavorite,
                onFavoriteToggle: () => ref.read(favoritesControllerProvider.notifier).toggle(vendor.id),
                width: cardWidth,
                onTap: () {},
              );
            },
          ),
        );
      },
    );
  }
}

class _SearchLoadingSkeleton extends StatelessWidget {
  const _SearchLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.md),
      children: [
        SkeletonBox(height: 220, borderRadius: AppRadius.xlRadius),
        const SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 220, borderRadius: AppRadius.xlRadius),
      ],
    );
  }
}
