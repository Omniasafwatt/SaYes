import 'package:flutter/material.dart';
import '../animations/shimmer_sweep.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

enum AppButtonVariant { primary, secondary, text }

/// The only button widget the app should use. Wraps Material buttons (so
/// theme-level styling, ink, and a11y stay intact) and adds a consistent
/// loading state so no screen has to hand-roll "disable + spinner" logic.
///
/// An enabled, non-loading primary button also carries the app's standard
/// static CTA shadow plus a slow gold shimmer sweep — the app's one
/// recurring "this is the one to tap" cue, so it stays a meaningful signal
/// rather than noise.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final spinnerColor = variant == AppButtonVariant.primary ? AppColors.textOnPrimary : AppColors.primary;

    final child = loading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.2, valueColor: AlwaysStoppedAnimation(spinnerColor)),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
              Text(label),
            ],
          );

    final button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(onPressed: loading ? null : onPressed, child: child),
      AppButtonVariant.secondary => OutlinedButton(onPressed: loading ? null : onPressed, child: child),
      AppButtonVariant.text => TextButton(onPressed: loading ? null : onPressed, child: child),
    };

    final isActivePrimary = variant == AppButtonVariant.primary && !loading && onPressed != null;

    final result = isActivePrimary
        ? DecoratedBox(
            decoration: BoxDecoration(borderRadius: AppRadius.fullRadius, boxShadow: AppShadows.cta),
            child: ClipRRect(
              borderRadius: AppRadius.fullRadius,
              child: ShimmerSweep(color: AppColors.gold, opacity: 0.28, child: button),
            ),
          )
        : button;

    return expand ? SizedBox(width: double.infinity, child: result) : result;
  }
}
