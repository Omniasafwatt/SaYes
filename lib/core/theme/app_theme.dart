import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

/// Assembles the app [ThemeData]. A dedicated instance is built per
/// language because font family + letter-spacing rules differ between
/// Latin and Arabic (see [AppTypographyExtension]).
///
/// Only a light theme exists for now — the brand is defined around a bright
/// ivory canvas; dark mode is out of scope until explicitly requested.
abstract final class AppTheme {
  static ThemeData light({required bool arabic}) {
    final typography = AppTypographyExtension.build(arabic: arabic);
    final baseFontFamily = arabic ? AppFontFamily.arabicSans : AppFontFamily.latinSans;

    final colorScheme = const ColorScheme.light().copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDeep,
      secondary: AppColors.gold,
      onSecondary: AppColors.textPrimary,
      tertiary: AppColors.roseGold,
      onTertiary: AppColors.textOnPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceBlush,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      outline: AppColors.outlineRose,
      outlineVariant: AppColors.outlineNeutral,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.ivory,
      fontFamily: baseFontFamily,
      splashFactory: InkSparkle.splashFactory,
      extensions: [typography],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: typography.titleLg,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      textTheme: TextTheme(
        displayLarge: typography.displayLg,
        displayMedium: typography.displaySm,
        headlineLarge: typography.headlineLg,
        headlineMedium: typography.headlineSm,
        titleLarge: typography.titleLg,
        titleMedium: typography.titleMd,
        bodyLarge: typography.bodyLg,
        bodyMedium: typography.bodyMd,
        labelLarge: typography.labelMd,
        labelSmall: typography.labelSm,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          textStyle: typography.button,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.fullRadius),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.gold),
          textStyle: typography.button.copyWith(color: AppColors.textPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.fullRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: typography.button.copyWith(color: AppColors.primary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: typography.bodyLg.copyWith(color: AppColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: AppRadius.fullRadius,
          borderSide: const BorderSide(color: AppColors.outlineRose),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.fullRadius,
          borderSide: const BorderSide(color: AppColors.outlineRose),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.fullRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.fullRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: typography.labelMd.copyWith(color: AppColors.textPrimary),
        secondaryLabelStyle: typography.labelMd.copyWith(color: AppColors.textOnPrimary),
        side: const BorderSide(color: AppColors.outlineRose),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.fullRadius),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
        margin: EdgeInsets.zero,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.ivory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
        showDragHandle: false,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
        titleTextStyle: typography.headlineSm,
        contentTextStyle: typography.bodyMd,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.outlineNeutral, thickness: 1, space: 1),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: typography.bodyMd.copyWith(color: AppColors.textOnPrimary),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        behavior: SnackBarBehavior.floating,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _SoftFadeSlideTransitionsBuilder(),
          TargetPlatform.iOS: _SoftFadeSlideTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Premium page transition used app-wide instead of Material's default
/// slide — a soft fade + gentle upward slide, per the brief's "no default
/// Flutter page transitions" rule.
class _SoftFadeSlideTransitionsBuilder extends PageTransitionsBuilder {
  const _SoftFadeSlideTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  }
}
