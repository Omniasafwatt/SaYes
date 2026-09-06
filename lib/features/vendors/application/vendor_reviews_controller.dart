import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/vendor_models.dart';
import '../data/vendor_repository.dart';

enum VendorReviewsStatus { loading, loadingMore, success, empty, error }

class VendorReviewsState {
  const VendorReviewsState({
    this.reviews = const [],
    this.status = VendorReviewsStatus.loading,
    this.page = 1,
    this.hasMore = false,
  });

  final List<ReviewModel> reviews;
  final VendorReviewsStatus status;
  final int page;
  final bool hasMore;
}

/// Drives the full Reviews screen's paginated list — one instance per
/// vendor, torn down when the screen is popped.
class VendorReviewsController extends AutoDisposeFamilyNotifier<VendorReviewsState, String> {
  @override
  VendorReviewsState build(String vendorId) {
    Future.microtask(() => _fetch(1));
    return const VendorReviewsState();
  }

  Future<void> _fetch(int page) async {
    state = VendorReviewsState(
      reviews: page == 1 ? const [] : state.reviews,
      status: page == 1 ? VendorReviewsStatus.loading : VendorReviewsStatus.loadingMore,
      page: state.page,
      hasMore: state.hasMore,
    );
    try {
      final result = await ref.read(vendorRepositoryProvider).getVendorReviews(vendorId: arg, page: page);
      final reviews = page == 1 ? result.reviews : [...state.reviews, ...result.reviews];
      state = VendorReviewsState(
        reviews: reviews,
        status: reviews.isEmpty ? VendorReviewsStatus.empty : VendorReviewsStatus.success,
        page: page,
        hasMore: result.hasMore,
      );
    } catch (_) {
      state = VendorReviewsState(reviews: state.reviews, status: VendorReviewsStatus.error, page: state.page);
    }
  }

  Future<void> loadMore() {
    if (state.status != VendorReviewsStatus.success || !state.hasMore) return Future.value();
    return _fetch(state.page + 1);
  }

  Future<void> retry() => _fetch(1);
}

final vendorReviewsControllerProvider =
    NotifierProvider.autoDispose.family<VendorReviewsController, VendorReviewsState, String>(
  VendorReviewsController.new,
);

/// Star-rating distribution for the bar chart at the top of the Reviews
/// screen — a plain FutureProvider, since unlike the review list itself it
/// has no pagination or mutable state.
final ratingBreakdownProvider = FutureProvider.autoDispose.family<RatingBreakdown, String>((ref, vendorId) {
  return ref.read(vendorRepositoryProvider).getRatingBreakdown(vendorId);
});
