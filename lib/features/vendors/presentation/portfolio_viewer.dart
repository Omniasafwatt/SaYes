import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';

/// Full-screen, swipeable, pinch-to-zoom viewer for a vendor's portfolio
/// photos. Opened from either the Vendor Details preview strip or the full
/// Portfolio grid, always at the tapped photo's index.
Future<void> showPortfolioViewer(
  BuildContext context, {
  required List<String> images,
  required int initialIndex,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      pageBuilder: (context, animation, secondaryAnimation) =>
          _PortfolioViewerScreen(images: images, initialIndex: initialIndex),
    ),
  );
}

class _PortfolioViewerScreen extends StatefulWidget {
  const _PortfolioViewerScreen({required this.images, required this.initialIndex});

  final List<String> images;
  final int initialIndex;

  @override
  State<_PortfolioViewerScreen> createState() => _PortfolioViewerScreenState();
}

class _PortfolioViewerScreenState extends State<_PortfolioViewerScreen> {
  late final PageController _pageController = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (page) => setState(() => _index = page),
              itemBuilder: (context, index) => InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(child: AppAssetImage(path: widget.images[index], fit: BoxFit.contain)),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.close_rounded, color: Colors.white),
                        ),
                      ),
                    ),
                    if (widget.images.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${_index + 1} / ${widget.images.length}',
                          textDirection: TextDirection.ltr,
                          style: context.typography.labelMd.copyWith(color: Colors.white),
                        ),
                      ),
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
