import 'package:go_router/go_router.dart';
import '../../features/design_system_showcase/design_system_showcase_screen.dart';

/// Route paths. Every screen the app can navigate to gets a named constant
/// here — no magic path strings scattered through feature code.
abstract final class AppRoutes {
  static const showcase = '/';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.showcase,
  routes: [
    GoRoute(
      path: AppRoutes.showcase,
      builder: (context, state) => const DesignSystemShowcaseScreen(),
    ),
  ],
);
