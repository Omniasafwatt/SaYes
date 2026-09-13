import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_models.dart';
import '../data/admin_repository.dart';

/// Drives the admin Categories screen — a small, non-paginated list (the
/// platform only ever has a handful of categories) with inline CRUD.
class AdminCategoriesController extends AsyncNotifier<List<AdminCategoryModel>> {
  @override
  Future<List<AdminCategoryModel>> build() => ref.read(adminRepositoryProvider).getCategories();

  Future<void> _reload() async {
    state = await AsyncValue.guard(() => ref.read(adminRepositoryProvider).getCategories());
  }

  Future<bool> create({required String name, required bool isActive}) async {
    try {
      await ref.read(adminRepositoryProvider).createCategory(name: name, isActive: isActive);
      await _reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> edit({required String id, String? name, bool? isActive}) async {
    try {
      await ref.read(adminRepositoryProvider).updateCategory(id: id, name: name, isActive: isActive);
      await _reload();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await ref.read(adminRepositoryProvider).deleteCategory(id);
      await _reload();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final adminCategoriesControllerProvider = AsyncNotifierProvider<AdminCategoriesController, List<AdminCategoryModel>>(
  AdminCategoriesController.new,
);
