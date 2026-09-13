import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Font families. Latin uses Playfair Display (serif, editorial) + Plus
/// Jakarta Sans (functional). Arabic uses a single family — Cairo —
/// everywhere, display and body alike, per explicit request rather than
/// pairing a separate Arabic serif with it.
abstract final class AppFontFamily {
  static const latinSerif = 'PlayfairDisplay';
  static const latinSans = 'PlusJakartaSans';
  static const arabicSans = 'Cairo';

  /// Script wordmark — the "SayYes" brand lockup only (splash, home nav).
  /// Never for body copy or Arabic (it has no Arabic glyphs).
  static const wordmark = 'BeauRivage';
}

/// Full named type scale, exposed as a [ThemeExtension] so every screen
/// reads styles via `context.typography.displayLg` instead of hard-coding
/// fontFamily/size/weight. Built separately per language because Arabic
/// must never carry negative Latin-style letter-tracking (it breaks glyph
/// joining), while Latin display text leans on tight tracking for its
/// editorial feel.
@immutable
class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  const AppTypographyExtension({
    required this.displayLg,
    required this.displaySm,
    required this.headlineLg,
    required this.headlineSm,
    required this.titleLg,
    required this.titleMd,
    required this.bodyLg,
    required this.bodyMd,
    required this.labelMd,
    required this.labelSm,
    required this.caption,
    required this.button,
    required this.price,
    required this.metadata,
  });

  final TextStyle displayLg;
  final TextStyle displaySm;
  final TextStyle headlineLg;
  final TextStyle headlineSm;
  final TextStyle titleLg;
  final TextStyle titleMd;
  final TextStyle bodyLg;
  final TextStyle bodyMd;
  final TextStyle labelMd;
  final TextStyle labelSm;
  final TextStyle caption;
  final TextStyle button;
  final TextStyle price;
  final TextStyle metadata;

  factory AppTypographyExtension.build({required bool arabic}) {
    final serif = arabic ? AppFontFamily.arabicSans : AppFontFamily.latinSerif;
    final sans = arabic ? AppFontFamily.arabicSans : AppFontFamily.latinSans;

    TextStyle style({
      required String family,
      required double size,
      required double lineHeight,
      required FontWeight weight,
      double letterSpacingEm = 0,
      Color color = AppColors.textPrimary,
    }) {
      return TextStyle(
        fontFamily: family,
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        // Arabic must keep natural (zero) tracking so letters stay joined.
        letterSpacing: arabic ? 0 : letterSpacingEm * size,
        color: color,
      );
    }

    return AppTypographyExtension(
      displayLg: style(family: serif, size: 40, lineHeight: 48, weight: FontWeight.w600, letterSpacingEm: -0.02),
      displaySm: style(family: serif, size: 30, lineHeight: 38, weight: FontWeight.w600, letterSpacingEm: -0.01),
      headlineLg: style(family: serif, size: 26, lineHeight: 34, weight: FontWeight.w600),
      headlineSm: style(family: serif, size: 20, lineHeight: 28, weight: FontWeight.w600),
      titleLg: style(family: sans, size: 18, lineHeight: 24, weight: FontWeight.w700, letterSpacingEm: -0.01),
      titleMd: style(family: sans, size: 16, lineHeight: 22, weight: FontWeight.w600),
      bodyLg: style(family: sans, size: 15, lineHeight: 22, weight: FontWeight.w400),
      bodyMd: style(family: sans, size: 14, lineHeight: 20, weight: FontWeight.w400, color: AppColors.textSecondary),
      labelMd: style(family: sans, size: 13, lineHeight: 16, weight: FontWeight.w600, letterSpacingEm: 0.02),
      labelSm: style(family: sans, size: 11, lineHeight: 14, weight: FontWeight.w700, letterSpacingEm: 0.04),
      caption: style(family: sans, size: 12, lineHeight: 16, weight: FontWeight.w400, color: AppColors.textSecondary),
      button: style(family: sans, size: 15, lineHeight: 20, weight: FontWeight.w700, letterSpacingEm: 0.01, color: AppColors.textOnPrimary),
      price: style(family: sans, size: 18, lineHeight: 24, weight: FontWeight.w700),
      metadata: style(family: sans, size: 11, lineHeight: 15, weight: FontWeight.w500, letterSpacingEm: 0.01, color: AppColors.textSecondary),
    );
  }

  @override
  AppTypographyExtension copyWith({
    TextStyle? displayLg,
    TextStyle? displaySm,
    TextStyle? headlineLg,
    TextStyle? headlineSm,
    TextStyle? titleLg,
    TextStyle? titleMd,
    TextStyle? bodyLg,
    TextStyle? bodyMd,
    TextStyle? labelMd,
    TextStyle? labelSm,
    TextStyle? caption,
    TextStyle? button,
    TextStyle? price,
    TextStyle? metadata,
  }) {
    return AppTypographyExtension(
      displayLg: displayLg ?? this.displayLg,
      displaySm: displaySm ?? this.displaySm,
      headlineLg: headlineLg ?? this.headlineLg,
      headlineSm: headlineSm ?? this.headlineSm,
      titleLg: titleLg ?? this.titleLg,
      titleMd: titleMd ?? this.titleMd,
      bodyLg: bodyLg ?? this.bodyLg,
      bodyMd: bodyMd ?? this.bodyMd,
      labelMd: labelMd ?? this.labelMd,
      labelSm: labelSm ?? this.labelSm,
      caption: caption ?? this.caption,
      button: button ?? this.button,
      price: price ?? this.price,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  AppTypographyExtension lerp(ThemeExtension<AppTypographyExtension>? other, double t) {
    if (other is! AppTypographyExtension) return this;
    return t < 0.5 ? this : other;
  }
}

extension AppTypographyContext on BuildContext {
  AppTypographyExtension get typography => Theme.of(this).extension<AppTypographyExtension>()!;
}
