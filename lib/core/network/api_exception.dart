/// A failed API call, already carrying a message safe to show a user
/// directly (extracted from the backend's `{message, error, statusCode}`
/// validation-error shape where possible, otherwise a generic fallback).
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;
  bool get isNotFound => statusCode == 404;
  bool get isValidation => statusCode == 400;

  @override
  String toString() => message;
}
