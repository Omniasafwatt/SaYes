import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/secure_storage_service.dart';
import 'auth_models.dart';

/// Contract the UI/controller layer codes against. Screens and
/// [AuthController] never know whether they're talking to a real backend
/// or the placeholder below — swapping the provider override is the only
/// change needed once a real API contract exists.
abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });

  Future<void> sendPasswordReset({required String email});

  Future<void> resetPassword({required String email, required String code, required String newPassword});

  Future<void> logout();
}

/// TEMPORARY placeholder implementation.
///
/// There is no backend yet (per the project brief: "Do not invent backend
/// endpoints... mark placeholder and ask for the API contract when
/// integration is needed"). This simulates network latency and basic
/// validation so the full UI — loading states, error states, session
/// persistence, splash session-restore — can be built and tested now.
/// Replace with a real [AuthRepository] implementation backed by Dio once
/// the API contract is provided; nothing above this class should need to
/// change.
class PlaceholderAuthRepository implements AuthRepository {
  PlaceholderAuthRepository(this._secureStorage);

  final SecureStorageService _secureStorage;

  Future<void> _simulateLatency() => Future.delayed(const Duration(milliseconds: 900));

  @override
  Future<void> login({required String email, required String password}) async {
    await _simulateLatency();
    await _secureStorage.saveSession(accessToken: 'placeholder-access-$email', refreshToken: 'placeholder-refresh-$email');
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await _simulateLatency();
    await _secureStorage.saveSession(accessToken: 'placeholder-access-$email', refreshToken: 'placeholder-refresh-$email');
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await _simulateLatency();
  }

  @override
  Future<void> resetPassword({required String email, required String code, required String newPassword}) async {
    await _simulateLatency();
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearSession();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return PlaceholderAuthRepository(ref.watch(secureStorageServiceProvider));
});
