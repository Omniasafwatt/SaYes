import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/pagination.dart';
import 'admin_analytics.dart';
import 'admin_models.dart';
import 'admin_models_subscription.dart';

Map<String, dynamic> _cleanQuery(Map<String, dynamic> query) {
  final clean = <String, dynamic>{};
  query.forEach((key, value) {
    if (value != null) clean[key] = value;
  });
  return clean;
}

/// Contract for the entire ADMIN back-office — dashboard, moderation
/// (vendors/users/bookings/reviews), categories, subscription plans,
/// system settings, and analytics. Kept as one repository since every
/// method here requires the same ADMIN role gate and lives under the
/// same `/admin` (or admin-gated shared) surface on the API.
abstract class AdminRepository {
  Future<AdminDashboardStats> getDashboardStats();

  // Categories
  Future<List<AdminCategoryModel>> getCategories();
  Future<void> createCategory({required String name, required bool isActive});
  Future<void> updateCategory({required String id, String? name, bool? isActive});
  Future<void> deleteCategory(String id);

  // Vendors
  Future<ParsedPage> getVendors({required int page, int limit = 20, String? categoryId, String? city, bool? verifiedOnly});
  Future<AdminVendorSummary> getVendor(String id);
  Future<void> setVendorVerification({required String id, required bool isVerified});

  // Users
  Future<ParsedPage> getUsers({required int page, int limit = 20, AdminUserRole? role, bool? isActive, String? search});
  Future<AdminUserSummary> getUser(String id);
  Future<void> setUserRole({required String id, required AdminUserRole role});
  Future<void> setUserActive({required String id, required bool isActive});

  // Bookings
  Future<ParsedPage> getBookings({required int page, int limit = 20, BookingApiStatus? status, String? vendorId});
  Future<void> acceptBooking(String id);
  Future<void> rejectBooking(String id);

  // Reviews
  Future<ParsedPage> getReviews({required int page, int limit = 20, String? vendorId, bool? hidden});
  Future<void> setReviewHidden({required String id, required bool isHidden});
  Future<void> deleteReview(String id);

  // Settings
  Future<SystemSettings> getSettings();
  Future<SystemSettings> updateSettings(SystemSettings settings);

  // Analytics
  Future<AnalyticsReport> getRevenueAnalytics({DateTime? from, DateTime? to});
  Future<AnalyticsReport> getGrowthAnalytics({DateTime? from, DateTime? to});
  Future<AnalyticsReport> getBookingsAnalytics({DateTime? from, DateTime? to});
  Future<AnalyticsReport> getReviewsAnalytics({DateTime? from, DateTime? to});
  Future<AnalyticsReport> getConversionAnalytics();
  Future<AnalyticsReport> getTopCategoriesAnalytics({DateTime? from, DateTime? to, int topLimit = 10});

  // Subscription plans
  Future<List<AdminSubscriptionPlan>> getSubscriptionPlans();
  Future<void> createSubscriptionPlan({
    required String name,
    required String description,
    required int priceEgp,
    required String interval,
    required int priorityScore,
    int? maxPackages,
    int? maxPortfolioItems,
    required bool isFeatured,
    required bool isActive,
  });
  Future<void> updateSubscriptionPlan({
    required String id,
    String? name,
    String? description,
    int? priceEgp,
    int? maxPackages,
    int? maxPortfolioItems,
    bool? isFeatured,
  });
  Future<void> setSubscriptionPlanActive({required String id, required bool isActive});
  Future<void> deleteSubscriptionPlan(String id);

  // Vendor subscriptions (per-vendor assignment, surfaced from the vendor
  // detail screen rather than its own nav section)
  Future<AdminVendorSubscription?> getVendorSubscription(String vendorId);
  Future<void> assignVendorPlan({required String vendorId, required String planId});
  Future<void> changeVendorSubscriptionPlan({required String subscriptionId, required String planId});
  Future<void> cancelVendorSubscription(String subscriptionId);
  Future<void> deleteVendorSubscription(String subscriptionId);
}

class ApiAdminRepository implements AdminRepository {
  ApiAdminRepository(this._api);

  final ApiClient _api;

  @override
  Future<AdminDashboardStats> getDashboardStats() async {
    final data = await _api.get('/admin/dashboard') as Map<String, dynamic>;
    return AdminDashboardStats.fromJson(data);
  }

  // ── Categories ──────────────────────────────────────────────────────

  @override
  Future<List<AdminCategoryModel>> getCategories() async {
    final data = await _api.get('/admin/categories');
    final parsed = parsePage(data, requestedPage: 1);
    return [for (final item in parsed.items) AdminCategoryModel.fromJson(item as Map<String, dynamic>)];
  }

  @override
  Future<void> createCategory({required String name, required bool isActive}) async {
    await _api.post('/categories', data: {'name': name, 'isActive': isActive});
  }

  @override
  Future<void> updateCategory({required String id, String? name, bool? isActive}) async {
    await _api.patch('/categories/$id', data: _cleanQuery({'name': name, 'isActive': isActive}));
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _api.delete('/categories/$id');
  }

  // ── Vendors ─────────────────────────────────────────────────────────

  @override
  Future<ParsedPage> getVendors({
    required int page,
    int limit = 20,
    String? categoryId,
    String? city,
    bool? verifiedOnly,
  }) async {
    final data = await _api.get(
      '/admin/vendors',
      query: _cleanQuery({'page': page, 'limit': limit, 'categoryId': categoryId, 'city': city, 'verifiedOnly': verifiedOnly}),
    );
    return parsePage(data, requestedPage: page);
  }

  @override
  Future<AdminVendorSummary> getVendor(String id) async {
    final data = await _api.get('/admin/vendors/$id') as Map<String, dynamic>;
    return AdminVendorSummary.fromJson(data);
  }

  @override
  Future<void> setVendorVerification({required String id, required bool isVerified}) async {
    await _api.patch('/admin/vendors/$id/verification', data: {'isVerified': isVerified});
  }

  // ── Users ───────────────────────────────────────────────────────────

  @override
  Future<ParsedPage> getUsers({
    required int page,
    int limit = 20,
    AdminUserRole? role,
    bool? isActive,
    String? search,
  }) async {
    final data = await _api.get(
      '/admin/users',
      query: _cleanQuery({'page': page, 'limit': limit, 'role': role?.apiValue, 'isActive': isActive, 'search': search}),
    );
    return parsePage(data, requestedPage: page);
  }

  @override
  Future<AdminUserSummary> getUser(String id) async {
    final data = await _api.get('/admin/users/$id') as Map<String, dynamic>;
    return AdminUserSummary.fromJson(data);
  }

  @override
  Future<void> setUserRole({required String id, required AdminUserRole role}) async {
    await _api.patch('/admin/users/$id/role', data: {'role': role.apiValue});
  }

  @override
  Future<void> setUserActive({required String id, required bool isActive}) async {
    await _api.patch('/admin/users/$id/active', data: {'isActive': isActive});
  }

  // ── Bookings ────────────────────────────────────────────────────────

  @override
  Future<ParsedPage> getBookings({
    required int page,
    int limit = 20,
    BookingApiStatus? status,
    String? vendorId,
  }) async {
    final data = await _api.get(
      '/admin/bookings',
      query: _cleanQuery({'page': page, 'limit': limit, 'status': status?.name.toUpperCase(), 'vendorId': vendorId}),
    );
    return parsePage(data, requestedPage: page);
  }

  @override
  Future<void> acceptBooking(String id) async {
    await _api.patch('/admin/bookings/$id/accept');
  }

  @override
  Future<void> rejectBooking(String id) async {
    await _api.patch('/admin/bookings/$id/reject');
  }

  // ── Reviews ─────────────────────────────────────────────────────────

  @override
  Future<ParsedPage> getReviews({required int page, int limit = 20, String? vendorId, bool? hidden}) async {
    final data = await _api.get(
      '/admin/reviews',
      query: _cleanQuery({'page': page, 'limit': limit, 'vendorId': vendorId, 'hidden': hidden}),
    );
    return parsePage(data, requestedPage: page);
  }

  @override
  Future<void> setReviewHidden({required String id, required bool isHidden}) async {
    await _api.patch('/admin/reviews/$id/hidden', data: {'isHidden': isHidden});
  }

  @override
  Future<void> deleteReview(String id) async {
    await _api.delete('/admin/reviews/$id');
  }

  // ── Settings ────────────────────────────────────────────────────────

  @override
  Future<SystemSettings> getSettings() async {
    final data = await _api.get('/admin/settings') as Map<String, dynamic>;
    return SystemSettings.fromJson(data);
  }

  @override
  Future<SystemSettings> updateSettings(SystemSettings settings) async {
    final data = await _api.patch('/admin/settings', data: settings.toJson()) as Map<String, dynamic>;
    return SystemSettings.fromJson(data);
  }

  // ── Analytics ───────────────────────────────────────────────────────

  Map<String, dynamic> _rangeQuery(DateTime? from, DateTime? to) => _cleanQuery({
        'from': from?.toUtc().toIso8601String(),
        'to': to?.toUtc().toIso8601String(),
      });

  @override
  Future<AnalyticsReport> getRevenueAnalytics({DateTime? from, DateTime? to}) async {
    final data = await _api.get('/admin/analytics/revenue', query: _rangeQuery(from, to));
    return parseAnalyticsReport(data);
  }

  @override
  Future<AnalyticsReport> getGrowthAnalytics({DateTime? from, DateTime? to}) async {
    final data = await _api.get('/admin/analytics/growth', query: _rangeQuery(from, to));
    return parseAnalyticsReport(data);
  }

  @override
  Future<AnalyticsReport> getBookingsAnalytics({DateTime? from, DateTime? to}) async {
    final data = await _api.get('/admin/analytics/bookings', query: _rangeQuery(from, to));
    return parseAnalyticsReport(data);
  }

  @override
  Future<AnalyticsReport> getReviewsAnalytics({DateTime? from, DateTime? to}) async {
    final data = await _api.get('/admin/analytics/reviews', query: _rangeQuery(from, to));
    return parseAnalyticsReport(data);
  }

  @override
  Future<AnalyticsReport> getConversionAnalytics() async {
    final data = await _api.get('/admin/analytics/conversion');
    return parseAnalyticsReport(data);
  }

  @override
  Future<AnalyticsReport> getTopCategoriesAnalytics({DateTime? from, DateTime? to, int topLimit = 10}) async {
    final data = await _api.get(
      '/admin/analytics/top-categories',
      query: {..._rangeQuery(from, to), 'topLimit': topLimit},
    );
    return parseAnalyticsReport(data);
  }

  // ── Subscription plans ──────────────────────────────────────────────

  @override
  Future<List<AdminSubscriptionPlan>> getSubscriptionPlans() async {
    final data = await _api.get('/subscription-plans');
    final parsed = parsePage(data, requestedPage: 1);
    return [for (final item in parsed.items) AdminSubscriptionPlan.fromJson(item as Map<String, dynamic>)];
  }

  @override
  Future<void> createSubscriptionPlan({
    required String name,
    required String description,
    required int priceEgp,
    required String interval,
    required int priorityScore,
    int? maxPackages,
    int? maxPortfolioItems,
    required bool isFeatured,
    required bool isActive,
  }) async {
    await _api.post('/subscription-plans', data: {
      'name': name,
      'description': description,
      'price': priceEgp,
      'currency': 'EGP',
      'interval': interval,
      'priorityScore': priorityScore,
      'maxPackages': ?maxPackages,
      'maxPortfolioItems': ?maxPortfolioItems,
      'isFeatured': isFeatured,
      'isActive': isActive,
    });
  }

  @override
  Future<void> updateSubscriptionPlan({
    required String id,
    String? name,
    String? description,
    int? priceEgp,
    int? maxPackages,
    int? maxPortfolioItems,
    bool? isFeatured,
  }) async {
    await _api.patch('/subscription-plans/$id', data: _cleanQuery({
          'name': name,
          'description': description,
          'price': priceEgp,
          'maxPackages': maxPackages,
          'maxPortfolioItems': maxPortfolioItems,
          'isFeatured': isFeatured,
        }));
  }

  @override
  Future<void> setSubscriptionPlanActive({required String id, required bool isActive}) async {
    await _api.patch('/subscription-plans/$id/${isActive ? 'activate' : 'deactivate'}');
  }

  @override
  Future<void> deleteSubscriptionPlan(String id) async {
    await _api.delete('/subscription-plans/$id');
  }

  // ── Vendor subscriptions ────────────────────────────────────────────

  @override
  Future<AdminVendorSubscription?> getVendorSubscription(String vendorId) async {
    final data = await _api.get('/vendor-subscriptions', query: {'vendorId': vendorId, 'page': 1, 'limit': 1});
    final parsed = parsePage(data, requestedPage: 1);
    if (parsed.items.isEmpty) return null;
    return AdminVendorSubscription.fromJson(parsed.items.first as Map<String, dynamic>);
  }

  @override
  Future<void> assignVendorPlan({required String vendorId, required String planId}) async {
    final now = DateTime.now().toUtc();
    await _api.post('/vendor-subscriptions', data: {
      'vendorId': vendorId,
      'planId': planId,
      'status': 'ACTIVE',
      'startedAt': now.toIso8601String(),
      'currentPeriodEnd': now.add(const Duration(days: 30)).toIso8601String(),
    });
  }

  @override
  Future<void> changeVendorSubscriptionPlan({required String subscriptionId, required String planId}) async {
    await _api.patch('/vendor-subscriptions/$subscriptionId', data: {'planId': planId});
  }

  @override
  Future<void> cancelVendorSubscription(String subscriptionId) async {
    await _api.patch('/vendor-subscriptions/$subscriptionId/cancel');
  }

  @override
  Future<void> deleteVendorSubscription(String subscriptionId) async {
    await _api.delete('/vendor-subscriptions/$subscriptionId');
  }
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) => ApiAdminRepository(ref.watch(apiClientProvider)));
