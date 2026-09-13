import '../localization/generated/app_localizations.dart';

/// Form field validators. Every message comes from [AppLocalizations] so
/// validation text is never hard-coded English inside a widget.
abstract final class Validators {
  static final _emailRegex = RegExp(r'^[\w.\-+]+@[\w\-]+\.[\w\-.]+$');

  static String? Function(String?) required(AppLocalizations l10n) {
    return (value) => (value == null || value.trim().isEmpty) ? l10n.validationRequired : null;
  }

  static String? Function(String?) email(AppLocalizations l10n) {
    return (value) {
      if (value == null || value.trim().isEmpty) return l10n.validationRequired;
      if (!_emailRegex.hasMatch(value.trim())) return l10n.validationEmailInvalid;
      return null;
    };
  }

  static String? Function(String?) password(AppLocalizations l10n) {
    return (value) {
      if (value == null || value.isEmpty) return l10n.validationRequired;
      if (value.length < 8) return l10n.validationPasswordTooShort;
      return null;
    };
  }

  static String? Function(String?) confirmPassword(AppLocalizations l10n, String Function() original) {
    return (value) {
      if (value == null || value.isEmpty) return l10n.validationRequired;
      if (value != original()) return l10n.validationPasswordMismatch;
      return null;
    };
  }

  static String? Function(String?) name(AppLocalizations l10n) {
    return (value) => (value == null || value.trim().length < 2) ? l10n.validationNameTooShort : null;
  }

  static final _phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');

  static String? Function(String?) phone(AppLocalizations l10n) {
    return (value) {
      if (value == null || value.trim().isEmpty) return l10n.validationRequired;
      if (!_phoneRegex.hasMatch(value.trim())) return l10n.validationPhoneInvalid;
      return null;
    };
  }

  static String? Function(String?) code(AppLocalizations l10n) {
    return (value) => (value == null || value.trim().length < 4) ? l10n.validationCodeTooShort : null;
  }
}
