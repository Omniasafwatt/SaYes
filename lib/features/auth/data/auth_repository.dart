import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../profile/data/user_profile.dart';
import '../../profile/data/user_profile_repository.dart';
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
  PlaceholderAuthRepository(this._secureStorage, this._userProfile);

  final SecureStorageService _secureStorage;
  final UserProfileRepository _userProfile;

  Future<void> _simulateLatency() => Future.delayed(const Duration(milliseconds: 900));

  @override
  Future<void> login({required String email, required String password}) async {
    await _simulateLatency();
    await _secureStorage.saveSession(accessToken: 'placeholder-access-$email', refreshToken: 'placeholder-refresh-$email');
    // No real backend to look up the account's actual name or role. If this
    // same email registered or logged in before on this device, its saved
    // profile (including any edits and its real role) carries over —
    // otherwise seed a fresh one from the email, defaulting to customer
    // since that's the far more common case and there's no way to ask
    // which role a not-yet-seen account actually is.
    final existing = await _userProfile.getProfile();
    if (existing == null || existing.email != email) {
      await _userProfile.saveProfile(UserProfile(name: email.split('@').first, email: email, role: UserRole.customer));
    }
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
    await _userProfile.saveProfile(UserProfile(name: name, email: email, role: role));
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
    // Deliberately keeps the cached profile — logging back in with the
    // same email should recall it, the way a real backend would. It's
    // only ever replaced, in login() above, when a different email signs
    // in on this device.
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return PlaceholderAuthRepository(ref.watch(secureStorageServiceProvider), ref.watch(userProfileRepositoryProvider));
});
