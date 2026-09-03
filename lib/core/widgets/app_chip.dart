import 'package:flutter/material.dart';
import '../animations/app_motion.dart';
import '../animations/pressable_scale.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

/// Pill filter/category chip. Selected state gets a solid magenta fill and
/// a soft rose glow — matches the Stitch "Filter & Category Chips" spec.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadius.fullRadius,
          border: Border.all(color: selected ? Colors.transparent : AppColors.outlineRose),
          boxShadow: selected ? AppShadows.glow : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: selected ? AppColors.textOnPrimary : AppColors.textSecondary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: context.typography.labelMd.copyWith(
                color: selected ? AppColors.textOnPrimary : AppColors.textPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
