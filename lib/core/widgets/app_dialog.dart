import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../animations/app_motion.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';

/// Confirmation-style dialog — e.g. "Upgrade your plan to add more
/// portfolio items." Primary/secondary labels are caller-supplied so this
/// stays localization-agnostic; [onPrimary]/[onSecondary] only need to
/// express what happens after the dialog closes — this widget always
/// dismisses itself first via the root navigator (matching where
/// [showDialog] pushes the route by default), so a caller whose own
/// context comes from inside a nested navigator (e.g. a
/// StatefulShellRoute branch) can't accidentally pop the wrong one.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  required String message,
  String? primaryLabel,
  VoidCallback? onPrimary,
  String? secondaryLabel,
  VoidCallback? onSecondary,
}) {
  return showDialog<T>(
    context: context,
    barrierColor: AppColors.textPrimary.withValues(alpha: 0.45),
    builder: (dialogContext) {
      void closeThen(VoidCallback? callback) {
        Navigator.of(dialogContext, rootNavigator: true).pop();
        callback?.call();
      }

      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: dialogContext.typography.headlineSm, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(message, style: dialogContext.typography.bodyMd, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xxl),
              if (primaryLabel != null)
                AppButton(label: primaryLabel, onPressed: () => closeThen(onPrimary)),
              if (secondaryLabel != null) ...[
                const SizedBox(height: AppSpacing.sm),
                AppButton(label: secondaryLabel, variant: AppButtonVariant.text, onPressed: () => closeThen(onSecondary)),
              ],
            ],
          ),
        ),
      ).animate().fadeIn(duration: AppMotion.fast).scale(
            begin: const Offset(0.92, 0.92),
            end: const Offset(1, 1),
            duration: AppMotion.medium,
            curve: AppMotion.spring,
          );
    },
  );
}
