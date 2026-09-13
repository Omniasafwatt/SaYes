import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_analytics.dart';
import '../data/admin_repository.dart';

/// Shared date range for the 5 range-based reports (Top Categories included
/// — only Conversion ignores it). One picker on the Analytics screen drives
/// all of them at once.
class AdminAnalyticsDateRange {
  const AdminAnalyticsDateRange({required this.from, required this.to});
  final DateTime from;
  final DateTime to;
}

AdminAnalyticsDateRange _defaultRange() {
  final now = DateTime.now();
  return AdminAnalyticsDateRange(from: DateTime(now.year, 1, 1), to: now);
}

final adminAnalyticsRangeProvider = StateProvider.autoDispose<AdminAnalyticsDateRange>((ref) => _defaultRange());

final adminRevenueAnalyticsProvider = FutureProvider.autoDispose<AnalyticsReport>((ref) {
  final range = ref.watch(adminAnalyticsRangeProvider);
  return ref.watch(adminRepositoryProvider).getRevenueAnalytics(from: range.from, to: range.to);
});

final adminGrowthAnalyticsProvider = FutureProvider.autoDispose<AnalyticsReport>((ref) {
  final range = ref.watch(adminAnalyticsRangeProvider);
  return ref.watch(adminRepositoryProvider).getGrowthAnalytics(from: range.from, to: range.to);
});

final adminBookingsAnalyticsProvider = FutureProvider.autoDispose<AnalyticsReport>((ref) {
  final range = ref.watch(adminAnalyticsRangeProvider);
  return ref.watch(adminRepositoryProvider).getBookingsAnalytics(from: range.from, to: range.to);
});

final adminReviewsAnalyticsProvider = FutureProvider.autoDispose<AnalyticsReport>((ref) {
  final range = ref.watch(adminAnalyticsRangeProvider);
  return ref.watch(adminRepositoryProvider).getReviewsAnalytics(from: range.from, to: range.to);
});

final adminTopCategoriesAnalyticsProvider = FutureProvider.autoDispose<AnalyticsReport>((ref) {
  final range = ref.watch(adminAnalyticsRangeProvider);
  return ref.watch(adminRepositoryProvider).getTopCategoriesAnalytics(from: range.from, to: range.to);
});

final adminConversionAnalyticsProvider = FutureProvider.autoDispose<AnalyticsReport>((ref) {
  return ref.watch(adminRepositoryProvider).getConversionAnalytics();
});
