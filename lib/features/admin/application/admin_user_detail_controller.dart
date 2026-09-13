import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_models.dart';
import '../data/admin_repository.dart';

class AdminUserDetailController extends AutoDisposeFamilyAsyncNotifier<AdminUserSummary, String> {
  @override
  Future<AdminUserSummary> build(String userId) => ref.read(adminRepositoryProvider).getUser(userId);

  Future<void> setRole(AdminUserRole role) async {
    await ref.read(adminRepositoryProvider).setUserRole(id: arg, role: role);
    ref.invalidateSelf();
  }

  Future<void> setActive(bool isActive) async {
    await ref.read(adminRepositoryProvider).setUserActive(id: arg, isActive: isActive);
    ref.invalidateSelf();
  }
}

final adminUserDetailControllerProvider =
    AsyncNotifierProvider.autoDispose.family<AdminUserDetailController, AdminUserSummary, String>(
  AdminUserDetailController.new,
);
