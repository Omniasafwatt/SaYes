import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';
import 'auth_models.dart';

/// Contract the UI/controller layer codes against. Screens and
/// [AuthController] never know the implementation details of the backend
/// call itself.
abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  });

  /// Returns the backend's dev-mode reset token when this deployment has no
  /// real email delivery configured and returns it directly in the response
  /// (see [ApiAuthRepository] doc comment); `null` when a real email was
  /// sent instead.
  Future<String?> sendPasswordReset({required String email});

  Future<void> resetPassword({required String email, required String code, required String newPassword});

  Future<void> logout();
}

/// Real implementation, backed by the deployed NestJS API. `login`/
/// `register` only return tokens (per the API) — this just stores them;
/// [AuthController] separately invalidates the cached profile right after,
/// which is what actually fetches `GET /users/me` for the account's real
/// name/role (via [UserProfileRepository]) — session-restore and
/// role-based routing already read that same cache. `email`/`code` isn't
/// part of the `/auth/reset-password` request (the backend only wants
/// `{token, newPassword}` — a `code` here is the token value); sending
/// extra fields would 400 under the API's `forbidNonWhitelisted`
/// validation.
class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._api, this._secureStorage);

  final ApiClient _api;
  final SecureStorageService _secureStorage;

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final accessToken = data['accessToken'] as String;
    final refreshToken = data['refreshToken'] as String;
    await _secureStorage.saveSession(accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    final data = await _api.post('/auth/login', data: {'email': email, 'password': password}) as Map<String, dynamic>;
    await _saveTokens(data);
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    final data = await _api.post('/auth/register', data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role.name.toUpperCase(),
    }) as Map<String, dynamic>;
    await _saveTokens(data);
  }

  @override
  Future<String?> sendPasswordReset({required String email}) async {
    final data = await _api.post('/auth/forgot-password', data: {'email': email});
    if (data is Map && data['token'] is String) return data['token'] as String;
    return null;
  }

  @override
  Future<void> resetPassword({required String email, required String code, required String newPassword}) async {
    await _api.post('/auth/reset-password', data: {'token': code, 'newPassword': newPassword});
  }

  @override
  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } catch (_) {
      // Best-effort: still clear the local session below even if the
      // server call fails (e.g. token already expired) — a stuck "can't
      // log out" is worse than a refresh token left valid server-side.
    }
    await _secureStorage.clearSession();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(ref.watch(apiClientProvider), ref.watch(secureStorageServiceProvider));
});
