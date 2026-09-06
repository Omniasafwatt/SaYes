import '../../auth/data/auth_models.dart';

/// The signed-in account's own profile — name and phone are locally
/// editable today; email is set once at registration and shown read-only
/// (changing it for real would need verification, which needs a real
/// backend). [role] drives which shell (customer vs vendor) the app routes
/// into on splash/login/register — see [UserRole].
class UserProfile {
  const UserProfile({required this.name, required this.email, this.phone, required this.role});

  final String name;
  final String email;
  final String? phone;
  final UserRole role;

  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'phone': phone, 'role': role.name};

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
        // Falls back to customer for profiles cached before this field
        // existed, rather than throwing on the very next session restore.
        role: UserRole.values.byName(json['role'] as String? ?? UserRole.customer.name),
      );
}
