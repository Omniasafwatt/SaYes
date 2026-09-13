import '../../../core/localization/generated/app_localizations.dart';
import '../data/admin_models.dart';

/// Localized display labels shared across the admin moderation screens.
String roleLabelForAdmin(AppLocalizations l10n, AdminUserRole role) => switch (role) {
      AdminUserRole.customer => l10n.adminRoleCustomer,
      AdminUserRole.vendor => l10n.adminRoleVendor,
      AdminUserRole.admin => l10n.adminRoleAdmin,
    };

String bookingStatusLabelForAdmin(AppLocalizations l10n, BookingApiStatus status) => switch (status) {
      BookingApiStatus.pending => l10n.adminBookingStatusPending,
      BookingApiStatus.accepted => l10n.adminBookingStatusAccepted,
      BookingApiStatus.rejected => l10n.adminBookingStatusRejected,
      BookingApiStatus.cancelled => l10n.adminBookingStatusCancelled,
    };
