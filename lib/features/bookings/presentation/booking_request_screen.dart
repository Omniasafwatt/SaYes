import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../application/bookings_controller.dart';
import '../data/booking_repository.dart';
import 'booking_success_screen.dart';

final _priceFormat = NumberFormat('#,##0', 'en_US');

/// Everything the booking request screen needs about the vendor + package
/// the customer just selected, carried from Vendor Packages via go_router's
/// `extra` rather than re-fetched.
class BookingRequestArgs {
  const BookingRequestArgs({
    required this.vendorId,
    required this.vendorName,
    required this.vendorImageAsset,
    required this.packageName,
    required this.packagePriceEgp,
  });

  final String vendorId;
  final String vendorName;
  final String vendorImageAsset;
  final String packageName;
  final int packagePriceEgp;
}

/// Collects event date, guest count, and an optional note, then submits the
/// request and hands off to [BookingSuccessScreen].
class BookingRequestScreen extends ConsumerStatefulWidget {
  const BookingRequestScreen({super.key, required this.args});

  final BookingRequestArgs args;

  @override
  ConsumerState<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends ConsumerState<BookingRequestScreen> {
  final _notesController = TextEditingController();
  DateTime? _eventDate;
  int _guestCount = 100;
  bool _submitting = false;
  String? _dateError;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? now.add(const Duration(days: 90)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() {
        _eventDate = picked;
        _dateError = null;
      });
    }
  }

  void _adjustGuestCount(int delta) {
    setState(() => _guestCount = (_guestCount + delta).clamp(10, 1000));
  }

  Future<void> _submit() async {
    if (_eventDate == null) {
      setState(() => _dateError = AppLocalizations.of(context).bookingRequestDateRequired);
      return;
    }
    setState(() {
      _submitting = true;
      _dateError = null;
    });
    try {
      final booking = await ref.read(bookingRepositoryProvider).submitBookingRequest(
            vendorId: widget.args.vendorId,
            vendorName: widget.args.vendorName,
            vendorImageAsset: widget.args.vendorImageAsset,
            packageName: widget.args.packageName,
            packagePriceEgp: widget.args.packagePriceEgp,
            eventDate: _eventDate!,
            guestCount: _guestCount,
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          );
      ref.read(bookingsControllerProvider.notifier).refresh();
      if (mounted) {
        context.pushReplacement(AppRoutes.bookingSuccess, extra: booking);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).bookingRequestErrorMessage)),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final dateLabel = _eventDate == null
        ? l10n.bookingRequestSelectDate
        : DateFormat.yMMMMd(Localizations.localeOf(context).toString()).format(_eventDate!);

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
                      l10n.bookingRequestTitle,
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
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.screenMargin),
                children: [
                  Text(l10n.bookingRequestSummary, style: context.typography.titleLg),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.lgRadius,
                      border: Border.all(color: AppColors.outlineNeutral),
                    ),
                    child: Row(
                      children: [
                        AppSmartImage(
                          path: widget.args.vendorImageAsset,
                          width: 56,
                          height: 56,
                          borderRadius: AppRadius.mdRadius,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.args.vendorName, style: context.typography.titleMd),
                              Text(widget.args.packageName, style: context.typography.bodyMd),
                            ],
                          ),
                        ),
                        Text(
                          l10n.egpAmountLabel(_priceFormat.format(widget.args.packagePriceEgp)),
                          style: context.typography.price,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  Text(l10n.bookingRequestEventDate, style: context.typography.titleLg),
                  const SizedBox(height: AppSpacing.sm),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: AppRadius.fullRadius,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.fullRadius,
                        border: Border.all(color: _dateError != null ? AppColors.error : AppColors.outlineRose),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: AppColors.textSecondary, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              dateLabel,
                              style: context.typography.bodyLg.copyWith(
                                color: _eventDate == null ? AppColors.textSecondary : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_dateError != null) ...[
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 4),
                      child: Text(_dateError!, style: context.typography.caption.copyWith(color: AppColors.error)),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sectionGap),

                  Text(l10n.bookingRequestGuestCount, style: context.typography.titleLg),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.fullRadius,
                      border: Border.all(color: AppColors.outlineRose),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _GuestCountButton(icon: Icons.remove_rounded, onTap: () => _adjustGuestCount(-10)),
                        Text('$_guestCount', style: context.typography.titleLg),
                        _GuestCountButton(icon: Icons.add_rounded, onTap: () => _adjustGuestCount(10)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  Text(l10n.bookingRequestNotes, style: context.typography.titleLg),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(hint: l10n.bookingRequestNotesHint, controller: _notesController, maxLines: 4),
                  const SizedBox(height: AppSpacing.sectionGap),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              child: AppButton(
                label: l10n.primaryButtonLabel,
                loading: _submitting,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestCountButton extends StatelessWidget {
  const _GuestCountButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceBlush,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
      ),
    );
  }
}
