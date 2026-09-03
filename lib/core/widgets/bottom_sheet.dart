import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../animations/app_motion.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

/// App-wide bottom sheet launcher — draggable handle, ivory canvas, and a
/// spring-settle entrance instead of the flat Material default.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _SpringSheetShell(child: builder(sheetContext)),
  );
}

class _SpringSheetShell extends StatelessWidget {
  const _SpringSheetShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.ivory,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
          boxShadow: AppShadows.sheet,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.outlineRose, borderRadius: AppRadius.fullRadius),
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: AppMotion.fast)
        .scaleY(alignment: Alignment.bottomCenter, begin: 0.96, end: 1, duration: AppMotion.medium, curve: AppMotion.spring);
  }
}
