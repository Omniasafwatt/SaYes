import 'package:flutter/animation.dart';

/// Shared durations and curves so motion feels consistent everywhere.
/// Nothing in the app should write a raw `Duration(milliseconds: ...)` or
/// `Curves.*` literal outside this file.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration medium = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 520);
  static const Duration page = Duration(milliseconds: 380);

  static const Curve entrance = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve spring = Curves.easeOutBack;
  static const Curve press = Curves.easeOut;

  /// Base delay step between successive items in a staggered list/grid.
  static const Duration staggerStep = Duration(milliseconds: 60);

  /// Cap on how many items get an individually-offset stagger delay before
  /// later items just reuse the max delay — keeps long lists from feeling
  /// like they take forever to finish animating in.
  static const int staggerCap = 8;
}
