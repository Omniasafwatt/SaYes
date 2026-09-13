import 'package:flutter/widgets.dart';
import 'app_colors.dart';

/// Tinted ambient shadows — no sterile grey drop shadows anywhere.
abstract final class AppShadows {
  /// Default card elevation: warm lift off the ivory canvas.
  static const List<BoxShadow> card = [
    BoxShadow(color: AppColors.glowCardBase, blurRadius: 16, offset: Offset(0, 4), spreadRadius: -2),
    BoxShadow(color: Color.fromARGB(8, 148, 137, 123), blurRadius: 3, offset: Offset(0, 1)),
  ];

  /// Floating action / concierge triggers, active discovery pills.
  static const List<BoxShadow> glow = [
    BoxShadow(color: Color.fromARGB(56, 148, 137, 123), blurRadius: 24, offset: Offset(0, 8), spreadRadius: -4),
  ];

  /// Primary CTA buttons.
  static const List<BoxShadow> cta = [
    BoxShadow(color: Color.fromARGB(77, 148, 137, 123), blurRadius: 20, offset: Offset(0, 8)),
  ];

  /// Modals / bottom sheets lifted well above content.
  static const List<BoxShadow> sheet = [
    BoxShadow(color: AppColors.glowCardBase, blurRadius: 32, offset: Offset(0, -8), spreadRadius: -4),
  ];
}
