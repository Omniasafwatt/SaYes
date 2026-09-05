import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_models.dart';
import '../data/auth_repository.dart';

/// Thin controller between the auth screens and [AuthRepository] — screens
/// never call the repository directly (Screen → Controller → Repository →
/// API, per the project architecture). Tracks the status of whichever auth
/// action was last attempted so screens can drive loading/error UI off one
/// piece of state.
class AuthController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> login({required String email, required String password}) => _run(
        () => ref.read(authRepositoryProvider).login(email: email, password: password),
      );

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) =>
      _run(
        () => ref.read(authRepositoryProvider).register(name: name, email: email, password: password, role: role),
      );

  Future<bool> sendPasswordReset({required String email}) => _run(
        () => ref.read(authRepositoryProvider).sendPasswordReset(email: email),
      );

  Future<bool> resetPassword({required String email, required String code, required String newPassword}) => _run(
        () => ref.read(authRepositoryProvider).resetPassword(email: email, code: code, newPassword: newPassword),
      );

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncValue.loading();
    try {
      await action();
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }
}

final authControllerProvider = NotifierProvider<AuthController, AsyncValue<void>>(AuthController.new);
