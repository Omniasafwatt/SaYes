import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../vendors/data/vendor_models.dart';
import '../../vendors/data/vendor_repository.dart';
import '../data/recent_searches_service.dart';

enum SearchStatus { empty, loading, loadingMore, success, noResults, error }

class SearchState {
  const SearchState({
    this.query = '',
    this.results = const [],
    this.status = SearchStatus.empty,
    this.page = 1,
    this.hasMore = false,
    this.recentSearches = const [],
  });

  final String query;
  final List<VendorSummary> results;
  final SearchStatus status;
  final int page;
  final bool hasMore;
  final List<String> recentSearches;
}

/// Drives the Search screen: debounced-by-the-UI query submission,
/// pagination (never loads everything at once), and locally persisted
/// recent searches. Screen → Controller → Repository, per the project
/// architecture — the screen never talks to [VendorRepository] directly.
class SearchController extends Notifier<SearchState> {
  @override
  SearchState build() {
    _loadRecent();
    return const SearchState();
  }

  Future<void> _loadRecent() async {
    final recents = await ref.read(recentSearchesServiceProvider).read();
    state = SearchState(
      query: state.query,
      results: state.results,
      status: state.status,
      page: state.page,
      hasMore: state.hasMore,
      recentSearches: recents,
    );
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      clearQuery();
      return;
    }

    state = SearchState(query: query, status: SearchStatus.loading, recentSearches: state.recentSearches);
    try {
      final result = await ref.read(vendorRepositoryProvider).search(query: query, page: 1);
      state = SearchState(
        query: query,
        results: result.vendors,
        hasMore: result.hasMore,
        page: 1,
        status: result.vendors.isEmpty ? SearchStatus.noResults : SearchStatus.success,
        recentSearches: state.recentSearches,
      );
      await ref.read(recentSearchesServiceProvider).add(query);
      await _loadRecent();
    } catch (_) {
      state = SearchState(query: query, status: SearchStatus.error, recentSearches: state.recentSearches);
    }
  }

  Future<void> loadMore() async {
    if (state.status != SearchStatus.success || !state.hasMore) return;
    state = SearchState(
      query: state.query,
      results: state.results,
      page: state.page,
      hasMore: state.hasMore,
      status: SearchStatus.loadingMore,
      recentSearches: state.recentSearches,
    );
    try {
      final nextPage = state.page + 1;
      final result = await ref.read(vendorRepositoryProvider).search(query: state.query, page: nextPage);
      state = SearchState(
        query: state.query,
        results: [...state.results, ...result.vendors],
        hasMore: result.hasMore,
        page: nextPage,
        status: SearchStatus.success,
        recentSearches: state.recentSearches,
      );
    } catch (_) {
      // Keep existing results visible; just stop the load-more spinner.
      state = SearchState(
        query: state.query,
        results: state.results,
        page: state.page,
        hasMore: state.hasMore,
        status: SearchStatus.success,
        recentSearches: state.recentSearches,
      );
    }
  }

  void clearQuery() {
    state = SearchState(recentSearches: state.recentSearches);
  }

  Future<void> removeRecent(String query) async {
    await ref.read(recentSearchesServiceProvider).remove(query);
    await _loadRecent();
  }

  Future<void> clearRecent() async {
    await ref.read(recentSearchesServiceProvider).clear();
    await _loadRecent();
  }
}

final searchControllerProvider = NotifierProvider<SearchController, SearchState>(SearchController.new);
