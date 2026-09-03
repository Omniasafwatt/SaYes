import 'dart:ui';
import 'package:flutter/material.dart';
import '../animations/pressable_scale.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Frosted translucent pill — for controls sitting on top of photography
/// (onboarding Skip, vendor-details hero back/share buttons, etc.) where a
/// solid surface color would look out of place against imagery.
class GlassPillButton extends StatelessWidget {
  const GlassPillButton({
    super.key,
    required this.label,
    this.onTap,
    this.foreground = Colors.white,
  });

  final String label;
  final VoidCallback? onTap;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: AppRadius.fullRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: AppRadius.fullRadius,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Text(
              label,
              style: context.typography.labelMd.copyWith(color: foreground, letterSpacing: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular frosted icon button — same treatment, for icon-only controls
/// (back arrow, favorite, share) floating over a hero image.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({super.key, required this.icon, this.onTap, this.foreground = Colors.white, this.size = 40});

  final IconData icon;
  final VoidCallback? onTap;
  final Color foreground;
  final double size;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: foreground, size: size * 0.5),
          ),
        ),
      ),
    );
  }
}
