import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_models.dart';
import '../data/admin_models_subscription.dart';
import '../data/admin_repository.dart';

class AdminVendorDetailState {
  const AdminVendorDetailState({required this.vendor, required this.subscription});
  final AdminVendorSummary vendor;
  final AdminVendorSubscription? subscription;
}

class AdminVendorDetailController extends AutoDisposeFamilyAsyncNotifier<AdminVendorDetailState, String> {
  @override
  Future<AdminVendorDetailState> build(String vendorId) async {
    final repo = ref.read(adminRepositoryProvider);
    final results = await Future.wait([repo.getVendor(vendorId), repo.getVendorSubscription(vendorId)]);
    return AdminVendorDetailState(
      vendor: results[0] as AdminVendorSummary,
      subscription: results[1] as AdminVendorSubscription?,
    );
  }

  Future<void> setVerification(bool isVerified) async {
    await ref.read(adminRepositoryProvider).setVendorVerification(id: arg, isVerified: isVerified);
    ref.invalidateSelf();
  }

  /// Assigns a plan for the first time (no existing subscription record)
  /// versus switching an existing one's plan — the API models these as two
  /// different operations (`POST` a new record vs `PATCH` an existing one),
  /// so the caller's current [AdminVendorDetailState.subscription] decides
  /// which this does.
  Future<bool> assignPlan(String planId) async {
    try {
      final currentSubscription = state.valueOrNull?.subscription;
      final repo = ref.read(adminRepositoryProvider);
      if (currentSubscription == null) {
        await repo.assignVendorPlan(vendorId: arg, planId: planId);
      } else {
        await repo.changeVendorSubscriptionPlan(subscriptionId: currentSubscription.id, planId: planId);
      }
      ref.invalidateSelf();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      await ref.read(adminRepositoryProvider).cancelVendorSubscription(subscriptionId);
      ref.invalidateSelf();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteSubscription(String subscriptionId) async {
    try {
      await ref.read(adminRepositoryProvider).deleteVendorSubscription(subscriptionId);
      ref.invalidateSelf();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final adminVendorDetailControllerProvider =
    AsyncNotifierProvider.autoDispose.family<AdminVendorDetailController, AdminVendorDetailState, String>(
  AdminVendorDetailController.new,
);
