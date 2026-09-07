import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/application/user_profile_controller.dart';
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

  /// login/register write straight to [UserProfileRepository] without
  /// going through [userProfileControllerProvider] — fine on a cold start
  /// where nothing has read that provider yet, but if it was already built
  /// (e.g. logging into a second account in the same running app session)
  /// it would otherwise keep serving whatever it resolved to before this
  /// call, never learning the repository underneath it just changed.
  void _refreshProfile() => ref.invalidate(userProfileControllerProvider);

  Future<bool> login({required String email, required String password}) async {
    final success = await _run(() => ref.read(authRepositoryProvider).login(email: email, password: password));
    if (success) _refreshProfile();
    return success;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final success = await _run(
      () => ref.read(authRepositoryProvider).register(name: name, email: email, password: password, role: role),
    );
    if (success) _refreshProfile();
    return success;
  }

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
