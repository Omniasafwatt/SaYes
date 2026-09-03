import 'package:flutter/material.dart';

/// Centralized brand palette for SayYes — Wedding Dream.
///
/// Ground truth is the rendered Stitch mockups (code.html across all 17
/// screens), not the raw Material-3 token dump in DESIGN.md's frontmatter.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFD93B78); // magenta — CTAs, active states
  static const Color primaryDeep = Color(0xFF9B1D54); // pressed / emphasis
  static const Color primaryLight = Color(0xFFF37AA6); // tertiary blush rose, glows
  static const Color gold = Color(0xFFD4AF37); // champagne gold — ratings, VIP, verified
  static const Color roseGold = Color(0xFFC58373);

  // Surfaces
  static const Color ivory = Color(0xFFFAF6F0); // base canvas
  static const Color ivoryEnd = Color(0xFFF4ECE4); // canvas gradient end
  static const Color champagne = Color(0xFFF8F4EC);
  static const Color surface = Color(0xFFFFFDFC); // cards / elevated ("Cream Luster")
  static const Color surfaceBlush = Color(0xFFFDF2F4); // muted petal blush tint

  // Borders / outlines
  static const Color outlineRose = Color(0xFFF6D5DF); // muted rose outline
  static const Color outlineNeutral = Color(0xFFEFE5E7);

  // Text
  static const Color textPrimary = Color(0xFF1F1F24); // deep charcoal espresso
  static const Color textSecondary = Color(0xFF6B565B); // soft muted secondary text
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFFAFA3A6);

  // Semantic status (kept warm/muted to stay inside the palette family)
  static const Color success = Color(0xFF4C7A5D);
  static const Color successContainer = Color(0xFFDCEEDF);
  static const Color pending = gold;
  static const Color pendingContainer = Color(0xFFFBF0D2);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Overlays / scrims (media card gradient footers)
  static const Color scrimTransparent = Color(0x001F1F24);
  static const Color scrimSolid = Color(0xD91F1F24); // ~85% charcoal

  // Ambient glow tints used in box shadows
  static const Color glowRose = Color(0x38D93B78); // rgba(217,59,120,0.22)
  static const Color glowCta = Color(0x4DD93B78); // rgba(217,59,120,0.3)
  static const Color glowCardTint = Color(0x08D93B78); // rgba(217,59,120,0.03)
  static const Color glowCardBase = Color(0x0A1F1F24); // rgba(31,31,36,0.04)
}
