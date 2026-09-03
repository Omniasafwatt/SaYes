import 'package:flutter/material.dart';
import '../animations/app_motion.dart';
import '../animations/pressable_scale.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// The ♡ → ❤ toggle used on every vendor card / details screen.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.isFavorite, required this.onToggle, this.size = 38});
  final bool isFavorite;
  final VoidCallback onToggle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onToggle,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: AppColors.surface.withValues(alpha: 0.92), shape: BoxShape.circle, boxShadow: AppShadows.card),
        child: Center(
          child: AnimatedSwitcher(
            duration: AppMotion.medium,
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: AppMotion.spring),
              child: child,
            ),
            child: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(isFavorite),
              color: isFavorite ? AppColors.primary : AppColors.textSecondary,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
