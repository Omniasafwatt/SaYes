import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/bookings/data/booking_models.dart';
import '../../features/bookings/presentation/booking_request_screen.dart';
import '../../features/bookings/presentation/booking_success_screen.dart';
import '../../features/categories/presentation/categories_screen.dart';
import '../../features/design_system_showcase/design_system_showcase_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/home/presentation/coming_soon_screen.dart';
import '../../features/home/presentation/customer_home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/presentation/profile_placeholder_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/vendors/presentation/vendor_detail_screen.dart';
import '../../features/vendors/presentation/vendor_listing_screen.dart';
import '../../features/vendors/presentation/vendor_packages_screen.dart';
import '../../features/vendors/presentation/vendor_portfolio_screen.dart';
import '../../features/vendors/presentation/vendor_reviews_screen.dart';
import '../localization/generated/app_localizations.dart';
import 'customer_shell.dart';

/// Route paths. Every screen the app can navigate to gets a named constant
/// here — no magic path strings scattered through feature code.
abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const showcase = '/showcase';

  static const home = '/home';
  static const search = '/search';
  static const vendorListing = '/vendor-listing';
  static const vendorDetail = '/vendor-detail';
  static const vendorPortfolio = '/vendor-portfolio';
  static const vendorPackages = '/vendor-packages';
  static const vendorReviews = '/vendor-reviews';
  static const bookingRequest = '/booking-request';
  static const bookingSuccess = '/booking-success';
  static const explore = '/explore';
  static const favorites = '/favorites';
  static const bookings = '/bookings';
  static const profile = '/profile';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) => ResetPasswordScreen(email: state.extra as String? ?? ''),
    ),
    GoRoute(
      path: AppRoutes.showcase,
      builder: (context, state) => const DesignSystemShowcaseScreen(),
    ),
    GoRoute(
      path: AppRoutes.search,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.vendorListing,
      builder: (context, state) => VendorListingScreen(args: state.extra as VendorListingScreenArgs),
    ),
    GoRoute(
      path: AppRoutes.vendorDetail,
      builder: (context, state) => VendorDetailScreen(vendorId: state.extra as String),
    ),
    GoRoute(
      path: AppRoutes.vendorPortfolio,
      builder: (context, state) => VendorPortfolioScreen(vendorId: state.extra as String),
    ),
    GoRoute(
      path: AppRoutes.vendorPackages,
      builder: (context, state) => VendorPackagesScreen(vendorId: state.extra as String),
    ),
    GoRoute(
      path: AppRoutes.vendorReviews,
      builder: (context, state) => VendorReviewsScreen(vendorId: state.extra as String),
    ),
    GoRoute(
      path: AppRoutes.bookingRequest,
      builder: (context, state) => BookingRequestScreen(args: state.extra as BookingRequestArgs),
    ),
    GoRoute(
      path: AppRoutes.bookingSuccess,
      builder: (context, state) => BookingSuccessScreen(booking: state.extra as BookingModel),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => CustomerShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.home, builder: (context, state) => const CustomerHomeScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.explore, builder: (context, state) => const CategoriesScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.favorites, builder: (context, state) => const FavoritesScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.bookings,
              builder: (context, state) {
                final l10n = AppLocalizations.of(context);
                return ComingSoonScreen(
                  icon: Icons.calendar_month_rounded,
                  title: l10n.comingSoonBookingsTitle,
                  message: l10n.comingSoonBookingsMessage,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfilePlaceholderScreen())],
        ),
      ],
    ),
  ],
);
