import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/pagination.dart';
import 'subscription_models.dart';

/// Contract for a vendor's own subscription — current plan and the catalog
/// of plans they could switch to.
abstract class SubscriptionRepository {
  Future<VendorSubscription> getMySubscription();
  Future<List<SubscriptionPlan>> getActivePlans();
  Future<void> switchPlan(String planId);
  Future<List<SubscriptionHistoryEntry>> getHistory();
}

class ApiSubscriptionRepository implements SubscriptionRepository {
  ApiSubscriptionRepository(this._api);

  final ApiClient _api;

  @override
  Future<VendorSubscription> getMySubscription() async {
    final data = await _api.get('/vendors/me/subscription') as Map<String, dynamic>;
    return VendorSubscription.fromJson(data);
  }

  @override
  Future<List<SubscriptionPlan>> getActivePlans() async {
    final data = await _api.get('/vendors/subscription-plans');
    final parsed = parsePage(data, requestedPage: 1);
    return [for (final item in parsed.items) SubscriptionPlan.fromJson(item as Map<String, dynamic>)];
  }

  @override
  Future<void> switchPlan(String planId) async {
    await _api.post('/vendors/me/subscription', data: {'planId': planId});
  }

  @override
  Future<List<SubscriptionHistoryEntry>> getHistory() async {
    final data = await _api.get('/vendors/me/subscription/history');
    final parsed = parsePage(data, requestedPage: 1);
    return [for (final item in parsed.items) SubscriptionHistoryEntry.fromJson(item as Map<String, dynamic>)];
  }
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => ApiSubscriptionRepository(ref.watch(apiClientProvider)),
);
