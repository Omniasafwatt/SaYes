import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/animations/pressable_scale.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/vendor_listing_controller.dart';
import '../data/vendor_listing_models.dart';

class VendorPortfolioManageScreen extends ConsumerWidget {
  const VendorPortfolioManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final listingAsync = ref.watch(vendorListingControllerProvider);

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
                      l10n.vendorListingPortfolioTitle,
                      style: context.typography.headlineSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: listingAsync.when(
                data: (listing) => _PortfolioBody(portfolio: listing.portfolio, l10n: l10n),
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.homeErrorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(vendorListingControllerProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioBody extends ConsumerStatefulWidget {
  const _PortfolioBody({required this.portfolio, required this.l10n});

  final List<PortfolioItemRef> portfolio;
  final AppLocalizations l10n;

  @override
  ConsumerState<_PortfolioBody> createState() => _PortfolioBodyState();
}

class _PortfolioBodyState extends ConsumerState<_PortfolioBody> {
  bool _uploading = false;

  Future<void> _pickAndUpload() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null || !mounted) return;
    setState(() => _uploading = true);
    try {
      await ref.read(vendorListingControllerProvider.notifier).addPortfolioImage(picked);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.l10n.errorMessage)));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _confirmRemove(PortfolioItemRef item) {
    return showAppDialog<void>(
      context: context,
      title: widget.l10n.vendorListingRemovePhotoTitle,
      message: widget.l10n.vendorListingRemovePhotoMessage,
      primaryLabel: widget.l10n.vendorListingRemoveAction,
      onPrimary: () => ref.read(vendorListingControllerProvider.notifier).removePortfolioImage(item.id),
      secondaryLabel: widget.l10n.searchCancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final portfolio = widget.portfolio;

    if (portfolio.isEmpty && !_uploading) {
      return AppStateView(
        icon: Icons.photo_library_outlined,
        title: l10n.vendorListingPortfolioEmptyTitle,
        message: l10n.vendorListingPortfolioEmptyMessage,
        actionLabel: l10n.vendorListingAddPhoto,
        onAction: _pickAndUpload,
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenMargin),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1,
      ),
      itemCount: portfolio.length + 1,
      itemBuilder: (context, index) {
        if (index == portfolio.length) {
          return _AddPhotoTile(loading: _uploading, onTap: _uploading ? null : _pickAndUpload);
        }
        final item = portfolio[index];
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(borderRadius: AppRadius.lgRadius, child: AppSmartImage(path: item.mediaUrl)),
            PositionedDirectional(
              top: 4,
              end: 4,
              child: _RemoveButton(onTap: () => _confirmRemove(item)),
            ),
          ],
        );
      },
    );
  }
}

/// The "add" affordance at the end of the portfolio grid — an outlined tile
/// with a centered icon, matching the tile size of the photos around it.
class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap, required this.loading});
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceBlush,
      borderRadius: AppRadius.lgRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.lgRadius,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
          ),
          child: Center(
            child: loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary, size: 28),
          ),
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(color: AppColors.surface.withValues(alpha: 0.92), shape: BoxShape.circle, boxShadow: AppShadows.card),
        child: const Icon(Icons.close_rounded, size: 15, color: AppColors.textPrimary),
      ),
    );
  }
}
