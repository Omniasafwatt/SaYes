import 'package:flutter/material.dart';
import '../../../../core/animations/pressable_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/widgets.dart';

/// Shared chrome for Login/Register: a full-bleed editorial hero image
/// fading into an ivory bottom sheet holding the form. Keeps both screens
/// visually identical apart from their content.
class AuthHeroScaffold extends StatelessWidget {
  const AuthHeroScaffold({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBack = false,
    this.heroHeight = 300,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final Widget child;
  final bool showBack;
  final double heroHeight;

  @override
  Widget build(BuildContext context) {
    final t = context.typography;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      resizeToAvoidBottomInset: true,
      // SizedBox.expand forces the Stack to the full body size. Without it,
      // a bare Stack sizes itself to its tallest non-positioned child (here,
      // the 300-tall hero image) instead of the screen — so a Positioned
      // with top/bottom both set collapses to almost nothing instead of
      // spanning down to the real bottom of the screen.
      body: SizedBox.expand(
        child: Stack(
          children: [
            SizedBox(
              height: heroHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(imagePath, fit: BoxFit.cover, alignment: Alignment.topCenter),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.35), Colors.transparent, AppColors.ivory],
                        stops: const [0, 0.55, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: heroHeight - 28,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.ivory,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
                  boxShadow: AppShadows.sheet,
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenMargin,
                      AppSpacing.lg,
                      AppSpacing.screenMargin,
                      AppSpacing.xxl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                            decoration: BoxDecoration(color: AppColors.outlineRose, borderRadius: AppRadius.fullRadius),
                          ),
                        ),
                        Text(title, textAlign: TextAlign.center, style: t.headlineLg),
                        const SizedBox(height: 4),
                        Text(subtitle, textAlign: TextAlign.center, style: t.bodyMd),
                        const SizedBox(height: AppSpacing.xxl),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    showBack
                        ? Transform.flip(
                            flipX: isRtl,
                            child: GlassIconButton(
                              icon: Icons.arrow_back_rounded,
                              onTap: () => Navigator.of(context).maybePop(),
                            ),
                          )
                        : const SizedBox(width: 40, height: 40),
                    const LanguageSwitcher(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simpler chrome for Forgot/Reset password — the ivory canvas with a back
/// button + language switcher, no hero photography. These are purely
/// functional screens; borrowing the editorial hero treatment here would
/// be decoration without purpose.
class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({super.key, required this.title, required this.subtitle, required this.child});

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.typography;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.flip(
                    flipX: isRtl,
                    child: _LightIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  const LanguageSwitcher(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    Text(title, style: t.headlineLg, textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(subtitle, style: t.bodyMd, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.sectionGap),
                    child,
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LightIconButton extends StatelessWidget {
  const _LightIconButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, boxShadow: AppShadows.card),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }
}
