import '../../auth/data/auth_models.dart';

/// The signed-in account's own profile — name and phone are locally
/// editable today; email is set once at registration and shown read-only
/// (changing it for real would need verification, which needs a real
/// backend). [role] drives which shell (customer vs vendor) the app routes
/// into on splash/login/register — see [UserRole].
class UserProfile {
  const UserProfile({required this.id, required this.name, required this.email, this.phone, required this.role});

  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email, 'phone': phone, 'role': role.name};

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String? ?? '',
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
        // The API returns roles upper-cased ("CUSTOMER"); lower-case before
        // matching against the enum's own (lower-case) names. Falls back to
        // customer if missing, rather than throwing on session restore.
        role: UserRole.values.byName((json['role'] as String? ?? UserRole.customer.name).toLowerCase()),
      );
}
