import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../animations/app_motion.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';

/// Shared shell for empty / error / success states. The brief is explicit
/// that these must never read as a generic "No data found" — so this
/// widget carries zero built-in copy. Every screen supplies its own icon,
/// title, message, and (optional) call to action, keeping the bespoke
/// wording while reusing one consistent layout, spacing, and entrance
/// animation everywhere it appears.
class AppStateView extends StatelessWidget {
  const AppStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconBackground,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final Color? iconBackground;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(color: iconBackground ?? AppColors.surfaceBlush, shape: BoxShape.circle),
              child: Icon(icon, size: 32, color: iconColor ?? AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(title, style: context.typography.headlineSm, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: context.typography.bodyMd, textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              AppButton(label: actionLabel!, onPressed: onAction, expand: false),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: AppMotion.medium).moveY(begin: 12, end: 0, duration: AppMotion.medium, curve: AppMotion.entrance);
  }
}
