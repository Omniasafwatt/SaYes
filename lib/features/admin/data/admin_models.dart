import '../../bookings/data/booking_message_codec.dart';

/// Platform-wide counters shown on the Admin Dashboard. The API's exact
/// field set for `GET /admin/dashboard` isn't pinned down beyond "platform
/// counters," so this reads every top-level numeric field it finds rather
/// than a fixed list — a metric the backend adds later shows up here
/// automatically instead of being silently dropped.
class AdminDashboardStats {
  const AdminDashboardStats({required this.counters});

  final Map<String, num> counters;

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    final counters = <String, num>{};
    json.forEach((key, value) {
      if (value is num) counters[key] = value;
    });
    return AdminDashboardStats(counters: counters);
  }
}

/// A category as the admin list sees it — same entity customers browse,
/// plus the `isActive`/`slug` fields only admins manage.
class AdminCategoryModel {
  const AdminCategoryModel({required this.id, required this.name, required this.slug, required this.isActive});

  final String id;
  final String name;
  final String slug;
  final bool isActive;

  factory AdminCategoryModel.fromJson(Map<String, dynamic> json) => AdminCategoryModel(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        isActive: json['isActive'] as bool? ?? true,
      );
}

/// One vendor row in the admin moderation list — a flatter, moderation-
/// focused slice than the customer-facing [VendorSummary] (adds contact
/// info and drops rating-derived display heuristics).
class AdminVendorSummary {
  const AdminVendorSummary({
    required this.id,
    required this.businessName,
    required this.email,
    required this.phone,
    required this.categoryName,
    required this.city,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.avatarUrl,
  });

  final String id;
  final String businessName;
  final String email;
  final String phone;
  final String categoryName;
  final String city;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String? avatarUrl;

  factory AdminVendorSummary.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;
    return AdminVendorSummary(
      id: json['id'] as String,
      businessName: (user?['name'] as String?) ?? 'Vendor',
      email: (user?['email'] as String?) ?? '',
      phone: (user?['phone'] as String?) ?? '',
      categoryName: (category?['name'] as String?) ?? '',
      city: json['city'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

enum AdminUserRole { customer, vendor, admin }

AdminUserRole _adminRoleFromApi(String? role) => switch (role?.toUpperCase()) {
      'VENDOR' => AdminUserRole.vendor,
      'ADMIN' => AdminUserRole.admin,
      _ => AdminUserRole.customer,
    };

extension AdminUserRoleApi on AdminUserRole {
  String get apiValue => switch (this) {
        AdminUserRole.customer => 'CUSTOMER',
        AdminUserRole.vendor => 'VENDOR',
        AdminUserRole.admin => 'ADMIN',
      };
}

/// One account row in the admin user-moderation list.
class AdminUserSummary {
  const AdminUserSummary({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final AdminUserRole role;
  final bool isActive;
  final DateTime? createdAt;

  factory AdminUserSummary.fromJson(Map<String, dynamic> json) => AdminUserSummary(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        role: _adminRoleFromApi(json['role'] as String?),
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      );
}

/// One booking row in the admin moderation list — sees both sides
/// (customer and vendor) that neither party's own list shows the other of.
class AdminBookingSummary {
  const AdminBookingSummary({
    required this.id,
    required this.customerName,
    required this.vendorName,
    required this.packageName,
    required this.eventDate,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String customerName;
  final String vendorName;
  final String packageName;
  final DateTime eventDate;
  final BookingApiStatus status;
  final DateTime createdAt;

  factory AdminBookingSummary.fromJson(Map<String, dynamic> json) {
    final customer = (json['customer'] ?? json['user']) as Map<String, dynamic>?;
    final vendor = json['vendor'] as Map<String, dynamic>?;
    final vendorUser = vendor?['user'] as Map<String, dynamic>?;
    final decoded = decodeBookingMessage(
      json['message'] as String?,
      fallbackVendorName: (vendorUser?['name'] as String?) ?? 'Vendor',
      fallbackPackageName: 'Booking request',
    );
    return AdminBookingSummary(
      id: json['id'] as String,
      customerName: (customer?['name'] as String?) ?? 'Customer',
      vendorName: (vendorUser?['name'] as String?) ?? decoded.vendorName,
      packageName: decoded.packageName,
      eventDate: DateTime.tryParse(json['eventDate'] as String? ?? '') ?? DateTime.now(),
      status: bookingApiStatusFromApi(json['status'] as String?),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

/// The raw uppercase API status, kept distinct from the customer-facing
/// [BookingStatus] enum since admin also sees bookings no customer-side
/// screen models (there is no admin-visible "cancelled" state client-side
/// otherwise).
enum BookingApiStatus { pending, accepted, rejected, cancelled }

BookingApiStatus bookingApiStatusFromApi(String? status) => switch (status?.toUpperCase()) {
      'ACCEPTED' => BookingApiStatus.accepted,
      'REJECTED' => BookingApiStatus.rejected,
      'CANCELLED' => BookingApiStatus.cancelled,
      _ => BookingApiStatus.pending,
    };

/// One review row in the admin moderation list.
class AdminReviewSummary {
  const AdminReviewSummary({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.isHidden,
    required this.createdAt,
  });

  final String id;
  final String vendorId;

  /// The API's `GET /admin/reviews` nests only `{id, city}` under `vendor`
  /// — no display name — so this is `null` whenever that's all we got, and
  /// the screen resolves a real name from [vendorId] via a small cached
  /// per-row lookup rather than showing a permanent "Vendor" placeholder.
  final String? vendorName;
  final String customerName;
  final double rating;
  final String comment;
  final bool isHidden;
  final DateTime createdAt;

  factory AdminReviewSummary.fromJson(Map<String, dynamic> json) {
    final vendor = json['vendor'] as Map<String, dynamic>?;
    final vendorUser = vendor?['user'] as Map<String, dynamic>?;
    final customer = (json['customer'] ?? json['user']) as Map<String, dynamic>?;
    return AdminReviewSummary(
      id: json['id'] as String,
      vendorId: (vendor?['id'] as String?) ?? json['vendorId'] as String? ?? '',
      vendorName: vendorUser?['name'] as String?,
      customerName: (customer?['name'] as String?) ?? 'Customer',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] as String? ?? '',
      isHidden: json['isHidden'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

/// Platform-wide configuration toggles — `GET`/`PATCH /admin/settings`.
class SystemSettings {
  const SystemSettings({
    required this.registrationEnabled,
    required this.maintenanceMode,
    required this.subscriptionRequired,
    required this.freeMode,
    required this.trialEnabled,
    required this.trialDays,
    required this.vendorAutoVerification,
    required this.uploadMaxSizeMb,
    required this.uploadAllowedTypes,
    required this.featuredSearch,
  });

  final bool registrationEnabled;
  final bool maintenanceMode;
  final bool subscriptionRequired;
  final bool freeMode;
  final bool trialEnabled;
  final int trialDays;
  final bool vendorAutoVerification;
  final int uploadMaxSizeMb;
  final List<String> uploadAllowedTypes;
  final bool featuredSearch;

  factory SystemSettings.fromJson(Map<String, dynamic> json) => SystemSettings(
        registrationEnabled: json['registrationEnabled'] as bool? ?? true,
        maintenanceMode: json['maintenanceMode'] as bool? ?? false,
        subscriptionRequired: json['subscriptionRequired'] as bool? ?? false,
        freeMode: json['freeMode'] as bool? ?? false,
        trialEnabled: json['trialEnabled'] as bool? ?? false,
        trialDays: (json['trialDays'] as num?)?.toInt() ?? 0,
        vendorAutoVerification: json['vendorAutoVerification'] as bool? ?? false,
        uploadMaxSizeMb: (json['uploadMaxSizeMb'] as num?)?.toInt() ?? 10,
        uploadAllowedTypes: (json['uploadAllowedTypes'] as List?)?.cast<String>() ?? const [],
        featuredSearch: json['featuredSearch'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'registrationEnabled': registrationEnabled,
        'maintenanceMode': maintenanceMode,
        'subscriptionRequired': subscriptionRequired,
        'freeMode': freeMode,
        'trialEnabled': trialEnabled,
        'trialDays': trialDays,
        'vendorAutoVerification': vendorAutoVerification,
        'uploadMaxSizeMb': uploadMaxSizeMb,
        'uploadAllowedTypes': uploadAllowedTypes,
        'featuredSearch': featuredSearch,
      };

  SystemSettings copyWith({
    bool? registrationEnabled,
    bool? maintenanceMode,
    bool? subscriptionRequired,
    bool? freeMode,
    bool? trialEnabled,
    int? trialDays,
    bool? vendorAutoVerification,
    int? uploadMaxSizeMb,
    List<String>? uploadAllowedTypes,
    bool? featuredSearch,
  }) {
    return SystemSettings(
      registrationEnabled: registrationEnabled ?? this.registrationEnabled,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      subscriptionRequired: subscriptionRequired ?? this.subscriptionRequired,
      freeMode: freeMode ?? this.freeMode,
      trialEnabled: trialEnabled ?? this.trialEnabled,
      trialDays: trialDays ?? this.trialDays,
      vendorAutoVerification: vendorAutoVerification ?? this.vendorAutoVerification,
      uploadMaxSizeMb: uploadMaxSizeMb ?? this.uploadMaxSizeMb,
      uploadAllowedTypes: uploadAllowedTypes ?? this.uploadAllowedTypes,
      featuredSearch: featuredSearch ?? this.featuredSearch,
    );
  }
}
