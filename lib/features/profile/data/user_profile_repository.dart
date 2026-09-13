import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import 'user_profile.dart';

/// Contract for reading and writing the signed-in account's own profile.
abstract class UserProfileRepository {
  Future<UserProfile?> getProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> clearProfile();
}

/// Real implementation — the profile lives entirely on the server now
/// (`GET`/`PATCH /users/me`), so there's nothing to cache locally or clear
/// on logout; every read is a fresh call, which is exactly what's needed
/// for role-based routing to stay correct if an admin changes an account's
/// role server-side between sessions.
class ApiUserProfileRepository implements UserProfileRepository {
  ApiUserProfileRepository(this._api);

  final ApiClient _api;

  @override
  Future<UserProfile?> getProfile() async {
    final data = await _api.get('/users/me') as Map<String, dynamic>;
    return UserProfile.fromJson(data);
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    // Only name and phone are ever mutable server-side (see API docs) —
    // email/role are set at registration and never sent back on a PATCH.
    await _api.patch('/users/me', data: {'name': profile.name, 'phone': profile.phone});
  }

  @override
  Future<void> clearProfile() async {
    // No-op: nothing cached locally to clear anymore.
  }
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>(
  (ref) => ApiUserProfileRepository(ref.watch(apiClientProvider)),
);
