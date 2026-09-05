import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/vendor_models.dart';
import '../data/vendor_repository.dart';

/// Identifies one vendor listing instance — a category, a city, or neither
/// (a plain "Featured"/"Popular" browse). Records give free structural
/// equality, which is exactly what a provider family key needs.
typedef VendorListingArgs = ({String? categoryId, String? city, SortOption initialSort});

enum VendorListingStatus { loading, loadingMore, success, empty, error }

class VendorListingState {
  const VendorListingState({
    this.vendors = const [],
    this.status = VendorListingStatus.loading,
    this.page = 1,
    this.hasMore = false,
    this.filters = const VendorFilters(),
  });

  final List<VendorSummary> vendors;
  final VendorListingStatus status;
  final int page;
  final bool hasMore;
  final VendorFilters filters;
}

/// Drives the full-screen vendor listing: paginated fetch scoped to a
/// category and/or city, plus the same [VendorFilters]/sort the filter
/// sheet edits. One instance per distinct [VendorListingArgs], torn down
/// when the screen is popped — this screen's filters are its own, separate
/// from Search's shared [vendorFiltersProvider].
class VendorListingController extends AutoDisposeFamilyNotifier<VendorListingState, VendorListingArgs> {
  @override
  VendorListingState build(VendorListingArgs arg) {
    final initial = VendorListingState(
      filters: VendorFilters(categoryId: arg.categoryId, city: arg.city, sort: arg.initialSort),
    );
    Future.microtask(() => _fetch(1, initial.filters));
    return initial;
  }

  Future<void> _fetch(int page, VendorFilters filters) async {
    state = VendorListingState(
      vendors: page == 1 ? const [] : state.vendors,
      status: page == 1 ? VendorListingStatus.loading : VendorListingStatus.loadingMore,
      page: state.page,
      hasMore: state.hasMore,
      filters: filters,
    );
    try {
      final result = await ref.read(vendorRepositoryProvider).search(query: '', page: page, filters: filters);
      final vendors = page == 1 ? result.vendors : [...state.vendors, ...result.vendors];
      state = VendorListingState(
        vendors: vendors,
        status: vendors.isEmpty ? VendorListingStatus.empty : VendorListingStatus.success,
        page: page,
        hasMore: result.hasMore,
        filters: filters,
      );
    } catch (_) {
      state = VendorListingState(
        vendors: state.vendors,
        status: VendorListingStatus.error,
        page: state.page,
        hasMore: state.hasMore,
        filters: filters,
      );
    }
  }

  Future<void> loadMore() {
    if (state.status != VendorListingStatus.success || !state.hasMore) return Future.value();
    return _fetch(state.page + 1, state.filters);
  }

  Future<void> applyFilters(VendorFilters filters) => _fetch(1, filters);

  Future<void> retry() => _fetch(1, state.filters);
}

final vendorListingControllerProvider =
    NotifierProvider.autoDispose.family<VendorListingController, VendorListingState, VendorListingArgs>(
  VendorListingController.new,
);
