import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/subscription_models.dart';
import '../data/subscription_repository.dart';

final mySubscriptionProvider = FutureProvider.autoDispose<VendorSubscription>((ref) {
  return ref.watch(subscriptionRepositoryProvider).getMySubscription();
});

final activePlansProvider = FutureProvider.autoDispose<List<SubscriptionPlan>>((ref) {
  return ref.watch(subscriptionRepositoryProvider).getActivePlans();
});

final mySubscriptionHistoryProvider = FutureProvider.autoDispose<List<SubscriptionHistoryEntry>>((ref) {
  return ref.watch(subscriptionRepositoryProvider).getHistory();
});

/// Drives the "switch plan" action on the Compare Plans screen. Kept
/// separate from [mySubscriptionProvider] so a switch's loading/error state
/// doesn't fight with the plan list's own loading state.
class SubscriptionSwitchController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> switchPlan(String planId) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => ref.read(subscriptionRepositoryProvider).switchPlan(planId));
    state = result;
    if (result.hasError) return false;
    ref.invalidate(mySubscriptionProvider);
    ref.invalidate(mySubscriptionHistoryProvider);
    return true;
  }
}

final subscriptionSwitchControllerProvider = AsyncNotifierProvider<SubscriptionSwitchController, void>(
  SubscriptionSwitchController.new,
);
