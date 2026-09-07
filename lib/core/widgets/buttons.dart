import 'package:flutter/material.dart';
import '../animations/app_motion.dart';
import '../animations/shimmer_sweep.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

enum AppButtonVariant { primary, secondary, text }

/// The only button widget the app should use. Wraps Material buttons (so
/// theme-level styling, ink, and a11y stay intact) and adds a consistent
/// loading state so no screen has to hand-roll "disable + spinner" logic.
///
/// An enabled, non-loading primary button also carries a soft breathing
/// glow and a slow gold shimmer sweep — the app's one recurring "this is
/// the one to tap" cue, so it stays a meaningful signal rather than noise.
class AppButton extends StatefulWidget {
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
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late final AnimationController _glowController =
      AnimationController(vsync: this, duration: AppMotion.glowPulse)..repeat(reverse: true);

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spinnerColor = widget.variant == AppButtonVariant.primary ? AppColors.textOnPrimary : AppColors.primary;

    final child = widget.loading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.2, valueColor: AlwaysStoppedAnimation(spinnerColor)),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[Icon(widget.icon, size: 18), const SizedBox(width: 8)],
              Text(widget.label),
            ],
          );

    final button = switch (widget.variant) {
      AppButtonVariant.primary => ElevatedButton(onPressed: widget.loading ? null : widget.onPressed, child: child),
      AppButtonVariant.secondary => OutlinedButton(onPressed: widget.loading ? null : widget.onPressed, child: child),
      AppButtonVariant.text => TextButton(onPressed: widget.loading ? null : widget.onPressed, child: child),
    };

    final isActivePrimary = widget.variant == AppButtonVariant.primary && !widget.loading && widget.onPressed != null;

    final result = isActivePrimary
        ? AnimatedBuilder(
            animation: _glowController,
            builder: (context, glowChild) => DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadius.fullRadius,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.glowCta.withValues(alpha: 0.28 + 0.22 * _glowController.value),
                    blurRadius: 16 + 10 * _glowController.value,
                    offset: const Offset(0, 6),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: glowChild,
            ),
            child: ClipRRect(
              borderRadius: AppRadius.fullRadius,
              child: ShimmerSweep(color: AppColors.gold, opacity: 0.28, child: button),
            ),
          )
        : button;

    return widget.expand ? SizedBox(width: double.infinity, child: result) : result;
  }
}
