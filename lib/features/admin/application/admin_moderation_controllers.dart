import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_models.dart';
import '../data/admin_repository.dart';

enum AdminListStatus { loading, loadingMore, success, empty, error }

// ── Vendors ─────────────────────────────────────────────────────────────

class AdminVendorFilters {
  const AdminVendorFilters({this.categoryId, this.city, this.verifiedOnly});
  final String? categoryId;
  final String? city;
  final bool? verifiedOnly;
}

class AdminVendorsState {
  const AdminVendorsState({
    this.vendors = const [],
    this.status = AdminListStatus.loading,
    this.page = 1,
    this.hasMore = false,
    this.filters = const AdminVendorFilters(),
  });

  final List<AdminVendorSummary> vendors;
  final AdminListStatus status;
  final int page;
  final bool hasMore;
  final AdminVendorFilters filters;
}

class AdminVendorsController extends AutoDisposeNotifier<AdminVendorsState> {
  @override
  AdminVendorsState build() {
    Future.microtask(() => _fetch(1));
    return const AdminVendorsState();
  }

  Future<void> _fetch(int page) async {
    state = AdminVendorsState(
      vendors: page == 1 ? const [] : state.vendors,
      status: page == 1 ? AdminListStatus.loading : AdminListStatus.loadingMore,
      page: state.page,
      hasMore: state.hasMore,
      filters: state.filters,
    );
    try {
      final parsed = await ref.read(adminRepositoryProvider).getVendors(
            page: page,
            categoryId: state.filters.categoryId,
            city: state.filters.city,
            verifiedOnly: state.filters.verifiedOnly,
          );
      final vendors = [for (final item in parsed.items) AdminVendorSummary.fromJson(item as Map<String, dynamic>)];
      final combined = page == 1 ? vendors : [...state.vendors, ...vendors];
      state = AdminVendorsState(
        vendors: combined,
        status: combined.isEmpty ? AdminListStatus.empty : AdminListStatus.success,
        page: page,
        hasMore: parsed.hasMore,
        filters: state.filters,
      );
    } catch (_) {
      state = AdminVendorsState(vendors: state.vendors, status: AdminListStatus.error, page: state.page, filters: state.filters);
    }
  }

  Future<void> loadMore() {
    if (state.status != AdminListStatus.success || !state.hasMore) return Future.value();
    return _fetch(state.page + 1);
  }

  Future<void> retry() => _fetch(1);

  Future<void> setFilters(AdminVendorFilters filters) {
    state = AdminVendorsState(status: AdminListStatus.loading, filters: filters);
    return _fetch(1);
  }

  Future<void> setVerification(String id, bool isVerified) async {
    await ref.read(adminRepositoryProvider).setVendorVerification(id: id, isVerified: isVerified);
    state = AdminVendorsState(
      vendors: [
        for (final v in state.vendors)
          if (v.id == id)
            AdminVendorSummary(
              id: v.id,
              businessName: v.businessName,
              email: v.email,
              phone: v.phone,
              categoryName: v.categoryName,
              city: v.city,
              rating: v.rating,
              reviewCount: v.reviewCount,
              isVerified: isVerified,
              avatarUrl: v.avatarUrl,
            )
          else
            v,
      ],
      status: state.status,
      page: state.page,
      hasMore: state.hasMore,
      filters: state.filters,
    );
  }
}

final adminVendorsControllerProvider = NotifierProvider.autoDispose<AdminVendorsController, AdminVendorsState>(
  AdminVendorsController.new,
);

// ── Users ───────────────────────────────────────────────────────────────

class AdminUserFilters {
  const AdminUserFilters({this.role, this.isActive, this.search});
  final AdminUserRole? role;
  final bool? isActive;
  final String? search;
}

class AdminUsersState {
  const AdminUsersState({
    this.users = const [],
    this.status = AdminListStatus.loading,
    this.page = 1,
    this.hasMore = false,
    this.filters = const AdminUserFilters(),
  });

  final List<AdminUserSummary> users;
  final AdminListStatus status;
  final int page;
  final bool hasMore;
  final AdminUserFilters filters;
}

class AdminUsersController extends AutoDisposeNotifier<AdminUsersState> {
  @override
  AdminUsersState build() {
    Future.microtask(() => _fetch(1));
    return const AdminUsersState();
  }

  Future<void> _fetch(int page) async {
    state = AdminUsersState(
      users: page == 1 ? const [] : state.users,
      status: page == 1 ? AdminListStatus.loading : AdminListStatus.loadingMore,
      page: state.page,
      hasMore: state.hasMore,
      filters: state.filters,
    );
    try {
      final parsed = await ref.read(adminRepositoryProvider).getUsers(
            page: page,
            role: state.filters.role,
            isActive: state.filters.isActive,
            search: state.filters.search,
          );
      final users = [for (final item in parsed.items) AdminUserSummary.fromJson(item as Map<String, dynamic>)];
      final combined = page == 1 ? users : [...state.users, ...users];
      state = AdminUsersState(
        users: combined,
        status: combined.isEmpty ? AdminListStatus.empty : AdminListStatus.success,
        page: page,
        hasMore: parsed.hasMore,
        filters: state.filters,
      );
    } catch (_) {
      state = AdminUsersState(users: state.users, status: AdminListStatus.error, page: state.page, filters: state.filters);
    }
  }

  Future<void> loadMore() {
    if (state.status != AdminListStatus.success || !state.hasMore) return Future.value();
    return _fetch(state.page + 1);
  }

  Future<void> retry() => _fetch(1);

  Future<void> setFilters(AdminUserFilters filters) {
    state = AdminUsersState(status: AdminListStatus.loading, filters: filters);
    return _fetch(1);
  }

  Future<void> setRole(String id, AdminUserRole role) async {
    await ref.read(adminRepositoryProvider).setUserRole(id: id, role: role);
    await _fetch(1);
  }

  Future<void> setActive(String id, bool isActive) async {
    await ref.read(adminRepositoryProvider).setUserActive(id: id, isActive: isActive);
    state = AdminUsersState(
      users: [
        for (final u in state.users)
          if (u.id == id)
            AdminUserSummary(id: u.id, name: u.name, email: u.email, phone: u.phone, role: u.role, isActive: isActive, createdAt: u.createdAt)
          else
            u,
      ],
      status: state.status,
      page: state.page,
      hasMore: state.hasMore,
      filters: state.filters,
    );
  }
}

final adminUsersControllerProvider = NotifierProvider.autoDispose<AdminUsersController, AdminUsersState>(
  AdminUsersController.new,
);

// ── Bookings ────────────────────────────────────────────────────────────

class AdminBookingFilters {
  const AdminBookingFilters({this.status, this.vendorId});
  final BookingApiStatus? status;
  final String? vendorId;
}

class AdminBookingsState {
  const AdminBookingsState({
    this.bookings = const [],
    this.status = AdminListStatus.loading,
    this.page = 1,
    this.hasMore = false,
    this.filters = const AdminBookingFilters(),
  });

  final List<AdminBookingSummary> bookings;
  final AdminListStatus status;
  final int page;
  final bool hasMore;
  final AdminBookingFilters filters;
}

class AdminBookingsController extends AutoDisposeNotifier<AdminBookingsState> {
  @override
  AdminBookingsState build() {
    Future.microtask(() => _fetch(1));
    return const AdminBookingsState();
  }

  Future<void> _fetch(int page) async {
    state = AdminBookingsState(
      bookings: page == 1 ? const [] : state.bookings,
      status: page == 1 ? AdminListStatus.loading : AdminListStatus.loadingMore,
      page: state.page,
      hasMore: state.hasMore,
      filters: state.filters,
    );
    try {
      final parsed = await ref.read(adminRepositoryProvider).getBookings(
            page: page,
            status: state.filters.status,
            vendorId: state.filters.vendorId,
          );
      final bookings = [for (final item in parsed.items) AdminBookingSummary.fromJson(item as Map<String, dynamic>)];
      final combined = page == 1 ? bookings : [...state.bookings, ...bookings];
      state = AdminBookingsState(
        bookings: combined,
        status: combined.isEmpty ? AdminListStatus.empty : AdminListStatus.success,
        page: page,
        hasMore: parsed.hasMore,
        filters: state.filters,
      );
    } catch (_) {
      state = AdminBookingsState(bookings: state.bookings, status: AdminListStatus.error, page: state.page, filters: state.filters);
    }
  }

  Future<void> loadMore() {
    if (state.status != AdminListStatus.success || !state.hasMore) return Future.value();
    return _fetch(state.page + 1);
  }

  Future<void> retry() => _fetch(1);

  Future<void> setFilters(AdminBookingFilters filters) {
    state = AdminBookingsState(status: AdminListStatus.loading, filters: filters);
    return _fetch(1);
  }

  Future<void> accept(String id) async {
    await ref.read(adminRepositoryProvider).acceptBooking(id);
    await _fetch(1);
  }

  Future<void> reject(String id) async {
    await ref.read(adminRepositoryProvider).rejectBooking(id);
    await _fetch(1);
  }
}

final adminBookingsControllerProvider = NotifierProvider.autoDispose<AdminBookingsController, AdminBookingsState>(
  AdminBookingsController.new,
);

// ── Reviews ─────────────────────────────────────────────────────────────

class AdminReviewFilters {
  const AdminReviewFilters({this.vendorId, this.hidden});
  final String? vendorId;
  final bool? hidden;
}

class AdminReviewsState {
  const AdminReviewsState({
    this.reviews = const [],
    this.status = AdminListStatus.loading,
    this.page = 1,
    this.hasMore = false,
    this.filters = const AdminReviewFilters(),
  });

  final List<AdminReviewSummary> reviews;
  final AdminListStatus status;
  final int page;
  final bool hasMore;
  final AdminReviewFilters filters;
}

class AdminReviewsController extends AutoDisposeNotifier<AdminReviewsState> {
  @override
  AdminReviewsState build() {
    Future.microtask(() => _fetch(1));
    return const AdminReviewsState();
  }

  Future<void> _fetch(int page) async {
    state = AdminReviewsState(
      reviews: page == 1 ? const [] : state.reviews,
      status: page == 1 ? AdminListStatus.loading : AdminListStatus.loadingMore,
      page: state.page,
      hasMore: state.hasMore,
      filters: state.filters,
    );
    try {
      final parsed = await ref.read(adminRepositoryProvider).getReviews(
            page: page,
            vendorId: state.filters.vendorId,
            hidden: state.filters.hidden,
          );
      final reviews = [for (final item in parsed.items) AdminReviewSummary.fromJson(item as Map<String, dynamic>)];
      final combined = page == 1 ? reviews : [...state.reviews, ...reviews];
      state = AdminReviewsState(
        reviews: combined,
        status: combined.isEmpty ? AdminListStatus.empty : AdminListStatus.success,
        page: page,
        hasMore: parsed.hasMore,
        filters: state.filters,
      );
    } catch (_) {
      state = AdminReviewsState(reviews: state.reviews, status: AdminListStatus.error, page: state.page, filters: state.filters);
    }
  }

  Future<void> loadMore() {
    if (state.status != AdminListStatus.success || !state.hasMore) return Future.value();
    return _fetch(state.page + 1);
  }

  Future<void> retry() => _fetch(1);

  Future<void> setFilters(AdminReviewFilters filters) {
    state = AdminReviewsState(status: AdminListStatus.loading, filters: filters);
    return _fetch(1);
  }

  Future<void> setHidden(String id, bool isHidden) async {
    await ref.read(adminRepositoryProvider).setReviewHidden(id: id, isHidden: isHidden);
    state = AdminReviewsState(
      reviews: [
        for (final r in state.reviews)
          if (r.id == id)
            AdminReviewSummary(
              id: r.id,
              vendorName: r.vendorName,
              customerName: r.customerName,
              rating: r.rating,
              comment: r.comment,
              isHidden: isHidden,
              createdAt: r.createdAt,
            )
          else
            r,
      ],
      status: state.status,
      page: state.page,
      hasMore: state.hasMore,
      filters: state.filters,
    );
  }

  Future<void> delete(String id) async {
    await ref.read(adminRepositoryProvider).deleteReview(id);
    state = AdminReviewsState(
      reviews: state.reviews.where((r) => r.id != id).toList(),
      status: state.status,
      page: state.page,
      hasMore: state.hasMore,
      filters: state.filters,
    );
  }
}

final adminReviewsControllerProvider = NotifierProvider.autoDispose<AdminReviewsController, AdminReviewsState>(
  AdminReviewsController.new,
);
