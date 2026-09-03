import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import 'app_motion.dart';

/// Elegant success confirmation mark — soft glow + scale/fade check, used
/// for booking success and similar confirmation moments. Deliberately
/// restrained: no confetti burst, matches the "do not overdo it" brief.
class SuccessCheck extends StatelessWidget {
  const SuccessCheck({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.glowRose, Colors.transparent],
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 0.9, end: 1.08, duration: const Duration(seconds: 2), curve: Curves.easeInOut),
          Container(
            width: size * 0.72,
            height: size * 0.72,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, color: AppColors.textOnPrimary, size: size * 0.4),
          )
              .animate()
              .scale(
                begin: const Offset(0.4, 0.4),
                end: const Offset(1, 1),
                duration: AppMotion.slow,
                curve: AppMotion.spring,
              )
              .fadeIn(duration: AppMotion.medium),
        ],
      ),
    );
  }
}
