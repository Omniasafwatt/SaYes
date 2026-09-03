import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../animations/pressable_scale.dart';
import '../localization/locale_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// The "AR | EN" pill toggle. Meant to be placed in headers/app bars
/// throughout the app — a first-class piece of the design, not a settings
/// menu afterthought, per the brief.
class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final isArabic = locale.isArabic;

    return PressableScale(
      onTap: () => ref.read(localeControllerProvider.notifier).toggle(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.85),
          borderRadius: AppRadius.fullRadius,
          border: Border.all(color: AppColors.outlineRose),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'AR',
              style: context.typography.labelSm.copyWith(
                color: isArabic ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text('|', style: context.typography.labelSm.copyWith(color: AppColors.outlineNeutral)),
            ),
            Text(
              'EN',
              style: context.typography.labelSm.copyWith(
                color: !isArabic ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
