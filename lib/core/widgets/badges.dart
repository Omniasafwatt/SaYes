import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

enum BookingStatus { pending, accepted, rejected }

/// Small status/identity pills. Every string comes from the caller so
/// these stay localization-agnostic — no hard-coded English inside a
/// reusable widget.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return _Badge(
      label: label,
      icon: Icons.verified_rounded,
      foreground: AppColors.primaryDeep,
      background: AppColors.surface,
      border: AppColors.gold,
    );
  }
}

class FeaturedBadge extends StatelessWidget {
  const FeaturedBadge({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return _Badge(
      label: label,
      icon: Icons.auto_awesome_rounded,
      foreground: AppColors.textPrimary,
      background: AppColors.gold,
      border: Colors.transparent,
    );
  }
}

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status, required this.label});
  final BookingStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = switch (status) {
      BookingStatus.pending => (AppColors.textPrimary, AppColors.pendingContainer),
      BookingStatus.accepted => (AppColors.success, AppColors.successContainer),
      BookingStatus.rejected => (AppColors.error, AppColors.errorContainer),
    };
    return _Badge(label: label, foreground: fg, background: bg, border: Colors.transparent);
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.foreground, required this.background, required this.border, this.icon});
  final String label;
  final Color foreground;
  final Color background;
  final Color border;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.fullRadius,
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: foreground), const SizedBox(width: 4)],
          Text(label, style: context.typography.labelSm.copyWith(color: foreground)),
        ],
      ),
    );
  }
}
