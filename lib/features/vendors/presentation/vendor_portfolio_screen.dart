import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/vendor_detail_controller.dart';
import 'portfolio_viewer.dart';

/// Full portfolio grid for one vendor — reached from the "See all" on the
/// Vendor Details preview strip. Reuses [vendorDetailProvider] rather than
/// a separate fetch, since the detail payload already carries the full
/// photo set.
class VendorPortfolioScreen extends ConsumerWidget {
  const VendorPortfolioScreen({super.key, required this.vendorId});

  final String vendorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(vendorDetailProvider(vendorId));

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
                      detailAsync.maybeWhen(data: (detail) => detail.name, orElse: () => l10n.vendorDetailPortfolio),
                      style: context.typography.headlineSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const LanguageSwitcher(),
                ],
              ),
            ),
            Expanded(
              child: detailAsync.when(
                data: (detail) => GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.screenMargin),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 1,
                  ),
                  itemCount: detail.imageAssets.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => showPortfolioViewer(context, images: detail.imageAssets, initialIndex: index),
                    child: AppAssetImage(path: detail.imageAssets[index], borderRadius: AppRadius.lgRadius),
                  ),
                ),
                loading: () => GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.screenMargin),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 1,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) => SkeletonBox(borderRadius: AppRadius.lgRadius),
                ),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.vendorDetailErrorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(vendorDetailProvider(vendorId)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
