import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_profile.dart';
import '../data/user_profile_repository.dart';

/// The signed-in customer's own profile. Null only in the moment before
/// the very first login/register has completed — every real session has
/// one, seeded at minimum from the account's email.
class UserProfileController extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() => ref.read(userProfileRepositoryProvider).getProfile();

  /// [phone] is the field's exact new value, including null to clear it —
  /// deliberately not [UserProfile.copyWith], whose `??` fallback can't
  /// express "set this back to empty."
  Future<void> updateProfile({required String name, String? phone}) async {
    final updated = UserProfile(name: name, email: state.value?.email ?? '', phone: phone);
    await ref.read(userProfileRepositoryProvider).saveProfile(updated);
    state = AsyncValue.data(updated);
  }
}

final userProfileControllerProvider = AsyncNotifierProvider<UserProfileController, UserProfile?>(
  UserProfileController.new,
);
