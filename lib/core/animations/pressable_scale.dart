import 'package:flutter/material.dart';
import 'app_motion.dart';

/// Subtle press feedback for cards, images, and custom (non-Material)
/// tappable surfaces — scales down slightly on press, springs back on
/// release. Buttons built on [ElevatedButton]/[OutlinedButton] already get
/// comparable feedback from the app theme's ink + Material motion, so this
/// is for the bespoke widgets (vendor cards, category tiles, chips-as-cards)
/// that aren't Material buttons underneath.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleTo = 0.97,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scaleTo;
  final BorderRadius? borderRadius;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.scaleTo : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.press,
        child: widget.child,
      ),
    );
  }
}
