/// The customer's own profile — name and phone are locally editable today;
/// email is set once at registration and shown read-only (changing it for
/// real would need verification, which needs a real backend).
class UserProfile {
  const UserProfile({required this.name, required this.email, this.phone});

  final String name;
  final String email;
  final String? phone;

  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'phone': phone};

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
      );
}
