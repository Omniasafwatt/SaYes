import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/animations/app_motion.dart';
import '../../core/animations/floating_petals.dart';
import '../../core/animations/pressable_scale.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';

const _kOnboardingImages = [
  'assets/images/bride_palace_staircase.png',
  'assets/images/wedding_ceremony_setup.png',
  'assets/images/wedding_hall_ballroom_tables.png',
];

/// Three-screen intro: dream wedding → trusted vendors → plan everything.
/// Backgrounds swipe natively via PageView; the text/CTA overlay is a
/// separate AnimatedSwitcher keyed on the page index, so copy always
/// fades in fresh regardless of PageView's own neighbor-prebuilding.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    context.go(AppRoutes.login);
  }

  void _next() {
    if (_page == 2) {
      _finish();
    } else {
      _controller.nextPage(duration: AppMotion.page, curve: AppMotion.entrance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      (headline: l10n.onboarding1Headline, body: l10n.onboarding1Body, footer: null),
      (headline: l10n.onboarding2Headline, body: l10n.onboarding2Body, footer: null),
      (headline: l10n.onboarding3Headline, body: l10n.onboarding3Body, footer: _FeatureChipsRow(l10n: l10n)),
    ];

    return Scaffold(
      backgroundColor: AppColors.textPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _kOnboardingImages.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => _OnboardingBackground(
              imagePath: _kOnboardingImages[i],
              showFloatingPetals: i == 0,
            ),
          ),
          SafeArea(
            child: _TopBar(showSkip: _page < 2, onSkip: _finish),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  0,
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: AppMotion.medium,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(animation),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(_page),
                        child: _OnboardingTextContent(
                          headline: pages[_page].headline,
                          body: pages[_page].body,
                          footer: pages[_page].footer,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        _PageIndicator(count: _kOnboardingImages.length, index: _page),
                        const Spacer(),
                        _NextButton(
                          isLast: _page == 2,
                          label: _page == 2 ? l10n.onboardingGetStarted : l10n.onboardingNext,
                          onTap: _next,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingBackground extends StatelessWidget {
  const _OnboardingBackground({required this.imagePath, this.showFloatingPetals = false});

  final String imagePath;
  final bool showFloatingPetals;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(imagePath, fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.15),
                Colors.black.withValues(alpha: 0.78),
              ],
              stops: const [0, 0.45, 1],
            ),
          ),
        ),
        if (showFloatingPetals)
          const Positioned.fill(
            child: FloatingPetals(petalCount: 7, color: Colors.white, maxOpacity: 0.5),
          ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.showSkip, required this.onSkip});

  final bool showSkip;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          showSkip ? GlassPillButton(label: l10n.onboardingSkip, onTap: onSkip) : const SizedBox(width: 1, height: 36),
          const LanguageSwitcher(),
        ],
      ),
    );
  }
}

class _OnboardingTextContent extends StatelessWidget {
  const _OnboardingTextContent({required this.headline, required this.body, this.footer});

  final String headline;
  final String body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final t = context.typography;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(headline, style: t.displaySm.copyWith(color: Colors.white)),
        const SizedBox(height: 10),
        Text(body, style: t.bodyMd.copyWith(color: Colors.white.withValues(alpha: 0.85))),
        if (footer != null) ...[const SizedBox(height: 18), footer!],
      ],
    );
  }
}

class _FeatureChipsRow extends StatelessWidget {
  const _FeatureChipsRow({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.storefront_rounded, l10n.onboarding3Vendors),
      (Icons.event_available_rounded, l10n.onboarding3Bookings),
      (Icons.favorite_rounded, l10n.onboarding3Favorites),
      (Icons.star_rounded, l10n.onboarding3Reviews),
    ];
    return Row(
      children: [
        for (final (icon, label) in items)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(height: 6),
                Text(label, style: context.typography.caption.copyWith(color: Colors.white.withValues(alpha: 0.85))),
              ],
            ),
          ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: AppMotion.medium,
          curve: AppMotion.entrance,
          margin: const EdgeInsetsDirectional.only(end: 6),
          width: active ? 26 : 7,
          height: 7,
          decoration: BoxDecoration(
            borderRadius: AppRadius.fullRadius,
            gradient: active ? const LinearGradient(colors: [AppColors.primary, AppColors.gold]) : null,
            color: active ? null : Colors.white.withValues(alpha: 0.4),
          ),
        );
      }),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.isLast, required this.label, required this.onTap});
  final bool isLast;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.only(start: 22, end: 8, top: 10, bottom: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDeep]),
          borderRadius: AppRadius.fullRadius,
          boxShadow: AppShadows.cta,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: context.typography.button),
            const SizedBox(width: 10),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), shape: BoxShape.circle),
              child: Transform.flip(
                flipX: !isLast && Directionality.of(context) == TextDirection.rtl,
                child: Icon(
                  isLast ? Icons.favorite_rounded : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
