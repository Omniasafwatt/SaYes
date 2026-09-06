import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/animations/entrance.dart';
import '../../../core/animations/floating_petals.dart';
import '../../../core/animations/success_check.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../data/booking_models.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// Dedicated confirmation moment after a booking request is sent — the
/// SuccessCheck + FloatingPetals pairing both note they were built for
/// exactly this screen back in the design-system phase, but this is the
/// first place either actually gets used for it.
class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Stack(
        children: [
          const Positioned.fill(child: FloatingPetals(petalCount: 7, maxOpacity: 0.3)),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              children: [
                const SizedBox(height: AppSpacing.sectionGap),
                Center(child: FadeSlideIn(child: const SuccessCheck(size: 128))),
                const SizedBox(height: AppSpacing.sectionGap),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: Text(l10n.successTitle, style: context.typography.headlineLg, textAlign: TextAlign.center),
                ),
                const SizedBox(height: AppSpacing.sm),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 120),
                  child: Text(l10n.successMessage, style: context.typography.bodyLg, textAlign: TextAlign.center),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 160),
                  child: _BookingSummaryCard(booking: booking, l10n: l10n),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      AppButton(label: l10n.successAction, onPressed: () => context.go(AppRoutes.home)),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        label: l10n.bookingSuccessViewBookings,
                        variant: AppButtonVariant.text,
                        onPressed: () => context.go(AppRoutes.bookings),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingSummaryCard extends StatelessWidget {
  const _BookingSummaryCard({required this.booking, required this.l10n});

  final BookingModel booking;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.outlineNeutral),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AppAssetImage(
                path: booking.vendorImageAsset,
                width: 56,
                height: 56,
                borderRadius: AppRadius.mdRadius,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.vendorName, style: context.typography.titleMd),
                    Text(booking.packageName, style: context.typography.bodyMd),
                  ],
                ),
              ),
              Text(
                l10n.egpAmountLabel(_priceFormat.format(booking.packagePriceEgp)),
                style: context.typography.price,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(),
          ),
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  DateFormat.yMMMMd(Localizations.localeOf(context).toString()).format(booking.eventDate),
                  style: context.typography.bodyMd,
                ),
              ),
              const Icon(Icons.groups_rounded, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(l10n.bookingSuccessGuestsLabel(booking.guestCount), style: context.typography.bodyMd),
            ],
          ),
        ],
      ),
    );
  }
}
