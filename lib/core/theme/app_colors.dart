import 'package:flutter/material.dart';

/// Centralized brand palette for SayYes — Wedding Dream.
///
/// Ground truth is the rendered Stitch mockups (code.html across all 17
/// screens), not the raw Material-3 token dump in DESIGN.md's frontmatter.
abstract final class AppColors {
  // Brand — deep wine family
  static const Color primary = Color(0xFF7F0F25); // the requested tone — CTAs, active states, wordmark
  static const Color primaryDeep = Color(0xFF530918); // pressed / emphasis, darkest wine
  static const Color primaryLight = Color(0xFFCD98A2); // dusty rose tint — soft accents, glows, botanical linework
  static const Color gold = Color(0xFFD4AF37); // champagne gold — ratings, VIP, verified
  static const Color roseGold = Color(0xFFB2344D); // raspberry rose — mid accent
  static const Color bronze = Color(0xFF8C693B); // warm bronze — used in place of gold in a few spots (stats, inspiration tags)

  // Surfaces — warm cream paper, lightest of all
  static const Color ivory = Color(0xFFFBF7F1); // base canvas
  static const Color ivoryEnd = Color(0xFFF5EDE3); // canvas gradient end
  static const Color champagne = Color(0xFFF8F1E7);
  static const Color surface = Color(0xFFFFFDFB); // cards / elevated ("Cream Luster")
  static const Color surfaceBlush = Color(0xFFF6E9EA); // muted dusty-rose tint

  // Borders / outlines
  static const Color outlineRose = Color(0xFFE9D3D6); // muted rose outline
  static const Color outlineNeutral = Color(0xFFEFE7DD);

  // Text
  static const Color textPrimary = Color(0xFF1F1F24); // deep charcoal espresso
  static const Color textSecondary = Color(0xFF6B6055); // soft muted secondary text
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFFAFA69C);

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
  static const Color glowRose = Color(0x387F0F25); // rgba(127,15,37,0.22)
  static const Color glowCta = Color(0x4D7F0F25); // rgba(127,15,37,0.3)
  static const Color glowCardTint = Color(0x087F0F25); // rgba(127,15,37,0.03)
  static const Color glowCardBase = Color(0x0A1F1F24); // rgba(31,31,36,0.04)
}
