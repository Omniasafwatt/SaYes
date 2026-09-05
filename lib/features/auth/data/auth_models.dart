/// The two account types a person can register as. Admin is a separate
/// web dashboard and never appears in this app — see the project brief.
///
/// This enum only drives which UI a screen shows (which nav shell, which
/// dashboard). It is NOT a security boundary — the backend is always the
/// source of truth for what a given account is actually allowed to do.
enum UserRole { customer, vendor }

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
