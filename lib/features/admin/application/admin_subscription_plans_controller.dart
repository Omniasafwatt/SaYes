import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_models_subscription.dart';
import '../data/admin_repository.dart';

class AdminSubscriptionPlansController extends AsyncNotifier<List<AdminSubscriptionPlan>> {
  @override
  Future<List<AdminSubscriptionPlan>> build() => ref.read(adminRepositoryProvider).getSubscriptionPlans();

  Future<void> _reload() async {
    state = await AsyncValue.guard(() => ref.read(adminRepositoryProvider).getSubscriptionPlans());
  }

  Future<bool> create({
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
    try {
      await ref.read(adminRepositoryProvider).createSubscriptionPlan(
            name: name,
            description: description,
            priceEgp: priceEgp,
            interval: interval,
            priorityScore: priorityScore,
            maxPackages: maxPackages,
            maxPortfolioItems: maxPortfolioItems,
            isFeatured: isFeatured,
            isActive: isActive,
          );
      await _reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> edit({
    required String id,
    String? name,
    String? description,
    int? priceEgp,
    int? maxPackages,
    int? maxPortfolioItems,
    bool? isFeatured,
  }) async {
    try {
      await ref.read(adminRepositoryProvider).updateSubscriptionPlan(
            id: id,
            name: name,
            description: description,
            priceEgp: priceEgp,
            maxPackages: maxPackages,
            maxPortfolioItems: maxPortfolioItems,
            isFeatured: isFeatured,
          );
      await _reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setActive(String id, bool isActive) async {
    try {
      await ref.read(adminRepositoryProvider).setSubscriptionPlanActive(id: id, isActive: isActive);
      await _reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await ref.read(adminRepositoryProvider).deleteSubscriptionPlan(id);
      await _reload();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final adminSubscriptionPlansControllerProvider =
    AsyncNotifierProvider<AdminSubscriptionPlansController, List<AdminSubscriptionPlan>>(
  AdminSubscriptionPlansController.new,
);
