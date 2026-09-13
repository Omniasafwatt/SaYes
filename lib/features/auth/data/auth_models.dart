/// The account types a real backend account can be. Self-registration only
/// ever produces `customer` or `vendor` (the server rejects `ADMIN` at
/// registration) — an admin account is promoted server-side by another
/// admin and simply logs in like anyone else, landing in the admin shell.
///
/// This enum only drives which UI a screen shows (which nav shell, which
/// dashboard). It is NOT a security boundary — the backend is always the
/// source of truth for what a given account is actually allowed to do.
enum UserRole { customer, vendor, admin }

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
