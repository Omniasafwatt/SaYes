import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/animations/pressable_scale.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../../bookings/presentation/booking_request_screen.dart';
import '../application/vendor_detail_controller.dart';
import '../data/vendor_models.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// Full package comparison for one vendor: every tier's inclusions in
/// detail, with a single selection that carries into (a not-yet-built)
/// booking request. Reached from the Vendor Details "See all" and from the
/// sticky "Request Booking" bar — choosing a package is the natural first
/// step of requesting one.
class VendorPackagesScreen extends ConsumerStatefulWidget {
  const VendorPackagesScreen({super.key, required this.vendorId});

  final String vendorId;

  @override
  ConsumerState<VendorPackagesScreen> createState() => _VendorPackagesScreenState();
}

class _VendorPackagesScreenState extends ConsumerState<VendorPackagesScreen> {
  String? _selectedPackageId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(vendorDetailProvider(widget.vendorId));

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
                      detailAsync.maybeWhen(data: (detail) => detail.name, orElse: () => l10n.vendorDetailPackages),
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
                data: (detail) => ListView(
                  padding: const EdgeInsets.all(AppSpacing.screenMargin),
                  children: [
                    for (final package in detail.packages) ...[
                      _SelectablePackageCard(
                        package: package,
                        selected: _selectedPackageId == package.id,
                        onTap: () => setState(() => _selectedPackageId = package.id),
                        l10n: l10n,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
                loading: () => ListView(
                  padding: const EdgeInsets.all(AppSpacing.screenMargin),
                  children: [
                    SkeletonBox(height: 160, borderRadius: AppRadius.lgRadius),
                    const SizedBox(height: AppSpacing.md),
                    SkeletonBox(height: 160, borderRadius: AppRadius.lgRadius),
                  ],
                ),
                error: (error, stackTrace) => AppStateView(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.errorTitle,
                  message: l10n.vendorDetailErrorMessage,
                  actionLabel: l10n.errorAction,
                  iconColor: AppColors.error,
                  iconBackground: AppColors.errorContainer,
                  onAction: () => ref.invalidate(vendorDetailProvider(widget.vendorId)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          decoration: const BoxDecoration(color: AppColors.surface, boxShadow: AppShadows.sheet),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedPackageId == null) ...[
                Text(l10n.vendorPackagesSelectPrompt, style: context.typography.bodyMd, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
              ],
              AppButton(
                label: l10n.vendorPackagesContinue,
                onPressed: _selectedPackageId == null
                    ? null
                    : () {
                        final detail = detailAsync.value!;
                        final package = detail.packages.firstWhere((p) => p.id == _selectedPackageId);
                        context.push(
                          AppRoutes.bookingRequest,
                          extra: BookingRequestArgs(
                            vendorId: detail.id,
                            vendorName: detail.name,
                            vendorImageAsset: detail.imageAssets.first,
                            packageName: package.name,
                            packagePriceEgp: package.priceEgp,
                          ),
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectablePackageCard extends StatelessWidget {
  const _SelectablePackageCard({
    required this.package,
    required this.selected,
    required this.onTap,
    required this.l10n,
  });

  final PackageModel package;
  final bool selected;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: selected ? AppColors.primary : AppColors.outlineNeutral, width: selected ? 2 : 1),
          boxShadow: selected ? AppShadows.glow : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  color: selected ? AppColors.primary : AppColors.outlineNeutral,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(package.name, style: context.typography.titleLg)),
                Text(l10n.egpAmountLabel(_priceFormat.format(package.priceEgp)), style: context.typography.price),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(package.description, style: context.typography.bodyMd),
            const SizedBox(height: AppSpacing.md),
            for (final inclusion in package.inclusions)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_rounded, size: 16, color: AppColors.success),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: Text(inclusion, style: context.typography.bodyMd)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
