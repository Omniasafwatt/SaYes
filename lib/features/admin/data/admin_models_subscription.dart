/// Admin-only view of a subscription plan — the same catalog entry a
/// vendor sees via `GET /vendors/subscription-plans` (see
/// `SubscriptionPlan` in the subscription feature), plus the
/// `isActive`/`priorityScore` fields only admin CRUD ever touches.
class AdminSubscriptionPlan {
  const AdminSubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.priceEgp,
    required this.interval,
    required this.priorityScore,
    required this.maxPackages,
    required this.maxPortfolioItems,
    required this.isFeatured,
    required this.isActive,
  });

  final String id;
  final String name;
  final String description;
  final int priceEgp;
  final String interval;
  final int priorityScore;
  final int? maxPackages;
  final int? maxPortfolioItems;
  final bool isFeatured;
  final bool isActive;

  static int _roundedPrice(dynamic price) {
    if (price is num) return price.round();
    return double.tryParse(price?.toString() ?? '0')?.round() ?? 0;
  }

  factory AdminSubscriptionPlan.fromJson(Map<String, dynamic> json) => AdminSubscriptionPlan(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        priceEgp: _roundedPrice(json['price']),
        interval: json['interval'] as String? ?? 'MONTHLY',
        priorityScore: (json['priorityScore'] as num?)?.toInt() ?? 0,
        maxPackages: (json['maxPackages'] as num?)?.toInt(),
        maxPortfolioItems: (json['maxPortfolioItems'] as num?)?.toInt(),
        isFeatured: json['isFeatured'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? true,
      );
}

/// One vendor's subscription record, as admin sees it via
/// `GET /vendor-subscriptions`. Distinct from the vendor's own "effective"
/// subscription view — this is the raw assignable record admin can cancel
/// or replace.
class AdminVendorSubscription {
  const AdminVendorSubscription({
    required this.id,
    required this.planName,
    required this.status,
    required this.currentPeriodEnd,
  });

  final String id;
  final String planName;
  final String status;
  final DateTime? currentPeriodEnd;

  factory AdminVendorSubscription.fromJson(Map<String, dynamic> json) {
    final plan = json['plan'] as Map<String, dynamic>?;
    return AdminVendorSubscription(
      id: json['id'] as String,
      planName: (plan?['name'] as String?) ?? '',
      status: json['status'] as String? ?? '',
      currentPeriodEnd: DateTime.tryParse(json['currentPeriodEnd'] as String? ?? ''),
    );
  }
}
