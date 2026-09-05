import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/animations/app_motion.dart';
import '../../core/animations/floating_petals.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/botanical_divider.dart';

/// First screen shown on launch. Shows the brand moment for a minimum
/// beat while checking for a stored session in parallel, then routes to
/// the signed-in destination or onboarding — the flow described in the
/// project brief's splash diagram. Role-based branching (customer vs
/// vendor shell) isn't wired yet since neither destination exists.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const _minimumDisplay = Duration(milliseconds: 2800);

  @override
  void initState() {
    super.initState();
    _resolveSession();
  }

  Future<void> _resolveSession() async {
    final results = await Future.wait([
      ref.read(secureStorageServiceProvider).hasSession(),
      Future.delayed(_minimumDisplay),
    ]);
    if (!mounted) return;
    final hasSession = results[0] as bool;
    context.go(hasSession ? AppRoutes.showcase : AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.typography;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.1,
            colors: [AppColors.champagne, AppColors.ivory, AppColors.ivoryEnd],
            stops: [0, 0.5, 1],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: FloatingPetals(petalCount: 9, maxOpacity: 0.4)),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  _Logo(),
                  const SizedBox(height: 14),
                  Text(
                    l10n.appTagline.toUpperCase(),
                    style: t.labelSm.copyWith(color: AppColors.roseGold),
                  ).animate(delay: AppMotion.medium).fadeIn(duration: AppMotion.slow),
                  const SizedBox(height: 6),
                  Text(l10n.appName, style: t.displayLg)
                      .animate(delay: const Duration(milliseconds: 460))
                      .fadeIn(duration: AppMotion.slow)
                      .moveY(begin: 10, end: 0, duration: AppMotion.slow, curve: AppMotion.entrance),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      l10n.splashSubtitle,
                      textAlign: TextAlign.center,
                      style: t.bodyMd.copyWith(fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                    ),
                  ).animate(delay: const Duration(milliseconds: 640)).fadeIn(duration: AppMotion.slow),
                  const Spacer(flex: 4),
                  const BotanicalDivider().animate(delay: const Duration(milliseconds: 900)).fadeIn(duration: AppMotion.slow),
                  const SizedBox(height: 16),
                  const _PulsingLoadingBar().animate(delay: const Duration(milliseconds: 1000)).fadeIn(duration: AppMotion.medium),
                  const SizedBox(height: 12),
                  Text(
                    l10n.splashCities,
                    style: t.caption.copyWith(letterSpacing: 1.2),
                  ).animate(delay: const Duration(milliseconds: 1000)).fadeIn(duration: AppMotion.medium),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      height: 168,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 168,
            height: 168,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [AppColors.glowRose, Colors.transparent]),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 0.94, end: 1.04, duration: const Duration(milliseconds: 3600), curve: Curves.easeInOut),
          Image.asset(
            'assets/images/logo_ring_emblem.png',
            width: 132,
            height: 132,
            fit: BoxFit.contain,
          ).animate().fadeIn(duration: AppMotion.slow).scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                duration: AppMotion.slow,
                curve: AppMotion.entrance,
              ),
        ],
      ),
    );
  }
}

/// Indeterminate progress cue — fills and settles rather than a default
/// spinner, matching the Stitch splash's loading-bar treatment.
class _PulsingLoadingBar extends StatefulWidget {
  const _PulsingLoadingBar();

  @override
  State<_PulsingLoadingBar> createState() => _PulsingLoadingBarState();
}

class _PulsingLoadingBarState extends State<_PulsingLoadingBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 4,
      child: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.outlineNeutral, borderRadius: AppRadius.fullRadius),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final value = Curves.easeInOutCubic.transform(_controller.value);
            return Align(
              alignment: Alignment(-1 + value * 2, 0),
              child: FractionallySizedBox(
                widthFactor: 0.45,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.fullRadius,
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.gold]),
                  ),
                  child: const SizedBox(height: 4),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
