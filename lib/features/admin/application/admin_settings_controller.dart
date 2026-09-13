import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_models.dart';
import '../data/admin_repository.dart';

class AdminSettingsController extends AsyncNotifier<SystemSettings> {
  @override
  Future<SystemSettings> build() => ref.read(adminRepositoryProvider).getSettings();

  Future<bool> save(SystemSettings settings) async {
    final previous = state;
    state = AsyncValue.data(settings);
    try {
      final saved = await ref.read(adminRepositoryProvider).updateSettings(settings);
      state = AsyncValue.data(saved);
      return true;
    } catch (_) {
      state = previous;
      return false;
    }
  }
}

final adminSettingsControllerProvider = AsyncNotifierProvider<AdminSettingsController, SystemSettings>(
  AdminSettingsController.new,
);
