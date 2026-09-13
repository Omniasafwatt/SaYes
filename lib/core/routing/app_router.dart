import 'package:go_router/go_router.dart';
import '../../features/admin/presentation/admin_analytics_screen.dart';
import '../../features/admin/presentation/admin_bookings_screen.dart';
import '../../features/admin/presentation/admin_categories_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/admin/presentation/admin_reviews_screen.dart';
import '../../features/admin/presentation/admin_settings_screen.dart';
import '../../features/admin/presentation/admin_subscription_plans_screen.dart';
import '../../features/admin/presentation/admin_user_detail_screen.dart';
import '../../features/admin/presentation/admin_users_screen.dart';
import '../../features/admin/presentation/admin_vendor_detail_screen.dart';
import '../../features/admin/presentation/admin_vendors_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/bookings/data/booking_models.dart';
import '../../features/bookings/presentation/booking_request_screen.dart';
import '../../features/bookings/presentation/booking_success_screen.dart';
import '../../features/bookings/presentation/customer_bookings_screen.dart';
import '../../features/categories/presentation/categories_screen.dart';
import '../../features/design_system_showcase/design_system_showcase_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/home/presentation/customer_home_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/subscription/presentation/compare_plans_screen.dart';
import '../../features/subscription/presentation/my_plan_screen.dart';
import '../../features/vendor_bookings/presentation/vendor_bookings_screen.dart';
import '../../features/vendor_dashboard/presentation/vendor_dashboard_screen.dart';
import '../../features/vendor_listing/presentation/vendor_business_details_screen.dart';
import '../../features/vendor_listing/presentation/vendor_packages_manage_screen.dart';
import '../../features/vendor_listing/presentation/vendor_portfolio_manage_screen.dart';
import '../../features/vendor_listing/presentation/vendor_setup_screen.dart';
import '../../features/vendor_profile/presentation/vendor_profile_screen.dart';
import '../../features/vendors/presentation/vendor_detail_screen.dart';
import '../../features/vendors/presentation/vendor_listing_screen.dart';
import '../../features/vendors/presentation/vendor_packages_screen.dart';
import '../../features/vendors/presentation/vendor_portfolio_screen.dart';
import '../../features/vendors/presentation/vendor_reviews_screen.dart';
import 'admin_shell.dart';
import 'customer_shell.dart';
import 'vendor_shell.dart';

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
  static const notifications = '/notifications';
  static const explore = '/explore';
  static const favorites = '/favorites';
  static const bookings = '/bookings';
  static const profile = '/profile';

  static const vendorSetup = '/vendor-setup';
  static const vendorHome = '/vendor-home';
  static const vendorBookings = '/vendor-bookings';
  static const vendorProfile = '/vendor-profile';
  static const vendorPortfolioManage = '/vendor-portfolio-manage';
  static const vendorPackagesManage = '/vendor-packages-manage';
  static const vendorBusinessDetails = '/vendor-business-details';
  static const subscription = '/subscription';
  static const subscriptionPlans = '/subscription-plans';

  static const adminHome = '/admin-home';
  static const adminVendors = '/admin-vendors';
  static const adminUsers = '/admin-users';
  static const adminBookings = '/admin-bookings';
  static const adminReviews = '/admin-reviews';
  static const adminCategories = '/admin-categories';
  static const adminSubscriptionPlans = '/admin-subscription-plans';
  static const adminAnalytics = '/admin-analytics';
  static const adminSettings = '/admin-settings';
  static const adminVendorDetail = '/admin-vendor-detail';
  static const adminUserDetail = '/admin-user-detail';
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
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.vendorPortfolioManage,
      builder: (context, state) => const VendorPortfolioManageScreen(),
    ),
    GoRoute(
      path: AppRoutes.vendorPackagesManage,
      builder: (context, state) => const VendorPackagesManageScreen(),
    ),
    GoRoute(
      path: AppRoutes.vendorBusinessDetails,
      builder: (context, state) => const VendorBusinessDetailsScreen(),
    ),
    GoRoute(
      path: AppRoutes.vendorSetup,
      builder: (context, state) => const VendorSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.subscription,
      builder: (context, state) => const MyPlanScreen(),
    ),
    GoRoute(
      path: AppRoutes.subscriptionPlans,
      builder: (context, state) => const ComparePlansScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminVendorDetail,
      builder: (context, state) => AdminVendorDetailScreen(vendorId: state.extra as String),
    ),
    GoRoute(
      path: AppRoutes.adminUserDetail,
      builder: (context, state) => AdminUserDetailScreen(userId: state.extra as String),
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
          routes: [GoRoute(path: AppRoutes.bookings, builder: (context, state) => const CustomerBookingsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen())],
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => VendorShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.vendorHome, builder: (context, state) => const VendorDashboardScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.vendorBookings, builder: (context, state) => const VendorBookingsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.vendorProfile, builder: (context, state) => const VendorProfileScreen())],
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AdminShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.adminHome, builder: (context, state) => const AdminDashboardScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.adminVendors, builder: (context, state) => const AdminVendorsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.adminUsers, builder: (context, state) => const AdminUsersScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.adminBookings, builder: (context, state) => const AdminBookingsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.adminReviews, builder: (context, state) => const AdminReviewsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.adminCategories, builder: (context, state) => const AdminCategoriesScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.adminSubscriptionPlans, builder: (context, state) => const AdminSubscriptionPlansScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.adminAnalytics, builder: (context, state) => const AdminAnalyticsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.adminSettings, builder: (context, state) => const AdminSettingsScreen())],
        ),
      ],
    ),
  ],
);
