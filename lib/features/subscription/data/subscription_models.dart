int _roundedPrice(dynamic price) {
  if (price is num) return price.round();
  return double.tryParse(price?.toString() ?? '0')?.round() ?? 0;
}

/// One plan a vendor can subscribe to. `maxPackages`/`maxPortfolioItems`
/// are null for an unlimited plan — the API only sends a cap when one
/// applies.
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.priceEgp,
    required this.interval,
    this.maxPackages,
    this.maxPortfolioItems,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String description;
  final int priceEgp;

  /// The API's `BillingInterval` enum value, e.g. `MONTHLY`/`YEARLY`.
  final String interval;
  final int? maxPackages;
  final int? maxPortfolioItems;
  final bool isFeatured;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => SubscriptionPlan(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        priceEgp: _roundedPrice(json['price']),
        interval: json['interval'] as String? ?? 'MONTHLY',
        maxPackages: (json['maxPackages'] as num?)?.toInt(),
        maxPortfolioItems: (json['maxPortfolioItems'] as num?)?.toInt(),
        isFeatured: json['isFeatured'] as bool? ?? false,
      );
}

const _freePlan = SubscriptionPlan(
  id: 'free',
  name: 'Free',
  description: 'Basic listing with standard limits.',
  priceEgp: 0,
  interval: 'MONTHLY',
);

/// A vendor's current subscription — the effective plan, its limits, and
/// current usage. `GET /vendors/me/subscription` nests everything under an
/// `effective` object (`{effective: {plan, maxPackages, maxPortfolioItems,
/// status, isTrialing, trialDaysRemaining, ...}, usage: {packages,
/// portfolioItems}}`) rather than returning the plan at the top level —
/// the effective limits are read from `effective` itself rather than
/// `effective.plan`, since they can be overridden independently of the
/// plan's own defaults (e.g. a trial). Every field still degrades
/// gracefully for an unrecognized shape rather than crashing My Plan.
class VendorSubscription {
  const VendorSubscription({
    required this.plan,
    required this.status,
    required this.maxPackages,
    required this.maxPortfolioItems,
    required this.isTrialing,
    required this.trialDaysRemaining,
  });

  final SubscriptionPlan plan;
  final String status;
  final int? maxPackages;
  final int? maxPortfolioItems;
  final bool isTrialing;
  final int trialDaysRemaining;

  factory VendorSubscription.fromJson(Map<String, dynamic> json) {
    final effective = json['effective'] as Map<String, dynamic>?;
    final planJson = effective?['plan'] as Map<String, dynamic>?;
    final plan = planJson != null ? SubscriptionPlan.fromJson(planJson) : _freePlan;
    return VendorSubscription(
      plan: plan,
      status: effective?['status'] as String? ?? 'ACTIVE',
      maxPackages: (effective?['maxPackages'] as num?)?.toInt() ?? plan.maxPackages,
      maxPortfolioItems: (effective?['maxPortfolioItems'] as num?)?.toInt() ?? plan.maxPortfolioItems,
      isTrialing: effective?['isTrialing'] as bool? ?? false,
      trialDaysRemaining: (effective?['trialDaysRemaining'] as num?)?.toInt() ?? 0,
    );
  }
}

/// One past or current subscription record from
/// `GET /vendors/me/subscription/history` — the vendor's own paper trail of
/// which plans they've been on, distinct from [VendorSubscription] (today's
/// effective, possibly-overridden view).
class SubscriptionHistoryEntry {
  const SubscriptionHistoryEntry({
    required this.planName,
    required this.status,
    required this.startedAt,
    required this.currentPeriodEnd,
  });

  final String planName;
  final String status;
  final DateTime? startedAt;
  final DateTime? currentPeriodEnd;

  factory SubscriptionHistoryEntry.fromJson(Map<String, dynamic> json) {
    final plan = json['plan'] as Map<String, dynamic>?;
    return SubscriptionHistoryEntry(
      planName: (plan?['name'] as String?) ?? '',
      status: json['status'] as String? ?? '',
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? ''),
      currentPeriodEnd: DateTime.tryParse(json['currentPeriodEnd'] as String? ?? ''),
    );
  }
}
