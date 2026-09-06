import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile.dart';

/// Contract for reading and writing the customer's own profile.
abstract class UserProfileRepository {
  Future<UserProfile?> getProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> clearProfile();
}

/// TEMPORARY placeholder implementation — same honest pattern as the other
/// Placeholder repositories: no backend exists yet to own profile data, so
/// this persists on-device via shared_preferences. Replace with a real
/// Dio-backed implementation once the API contract exists;
/// [UserProfileController] won't need to change.
class PlaceholderUserProfileRepository implements UserProfileRepository {
  static const _key = 'sayyes_user_profile';

  @override
  Future<UserProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(profile.toJson()));
  }

  @override
  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) => PlaceholderUserProfileRepository());
