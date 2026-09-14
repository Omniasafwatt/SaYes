/// The 6 analytics endpoints (`/admin/analytics/*`) each return their own
/// report-specific shape that isn't pinned down in the API docs beyond a
/// one-line description ("revenue/MRR over the range", "volume + status
/// distribution", etc). Rather than modeling six brittle, guessed shapes,
/// [AnalyticsReport] reads whatever comes back generically: every
/// top-level number becomes a summary stat, and the first list of records
/// (or map of label→number) becomes the chart series. A real response,
/// whatever its exact field names turn out to be, renders correctly;
/// nothing here can throw on an unrecognized shape.
class AnalyticsStat {
  const AnalyticsStat({required this.label, required this.value});
  final String label;
  final num value;
}

class AnalyticsSeriesPoint {
  const AnalyticsSeriesPoint({required this.label, required this.value});
  final String label;
  final num value;
}

class AnalyticsReport {
  const AnalyticsReport({required this.stats, required this.series});
  final List<AnalyticsStat> stats;
  final List<AnalyticsSeriesPoint> series;

  static const empty = AnalyticsReport(stats: [], series: []);
}

const _skipKeys = {'from', 'to', 'success', 'id'};
const _seriesLabelKeys = ['label', 'name', 'period', 'date', 'category', 'categoryName', 'status', 'rating', 'month', 'day'];
const _seriesValueKeys = [
  'value',
  'count',
  'amount',
  'total',
  'revenue',
  'bookings',
  'reviews',
  'bookingCount',
  'users',
  'vendorCount',
  'vendors',
];

String humanizeKey(String key) {
  final withSpaces = key.replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}');
  final words = withSpaces.split(RegExp(r'[_\s]+')).where((w) => w.isNotEmpty);
  return words.map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
}

AnalyticsReport parseAnalyticsReport(dynamic json) {
  final stats = <AnalyticsStat>[];
  List<AnalyticsSeriesPoint>? series;

  List<AnalyticsSeriesPoint>? tryListAsSeries(List list) {
    if (list.isEmpty) return null;
    final points = <AnalyticsSeriesPoint>[];
    for (final item in list) {
      if (item is! Map<String, dynamic>) return null;
      String? label;
      num? value;
      for (final key in _seriesLabelKeys) {
        if (item[key] != null) {
          label = item[key].toString();
          break;
        }
      }
      for (final key in _seriesValueKeys) {
        if (item[key] is num) {
          value = item[key] as num;
          break;
        }
      }
      if (label == null || value == null) return null;
      points.add(AnalyticsSeriesPoint(label: label, value: value));
    }
    return points;
  }

  List<AnalyticsSeriesPoint>? tryMapAsSeries(Map<String, dynamic> map) {
    if (map.isEmpty || !map.values.every((v) => v is num)) return null;
    return [for (final entry in map.entries) AnalyticsSeriesPoint(label: humanizeKey(entry.key), value: entry.value as num)];
  }

  void walk(Map<String, dynamic> map) {
    map.forEach((key, value) {
      if (_skipKeys.contains(key)) return;
      if (value is num) {
        stats.add(AnalyticsStat(label: humanizeKey(key), value: value));
      } else if (value is List && series == null) {
        series = tryListAsSeries(value);
      } else if (value is Map<String, dynamic>) {
        series ??= tryMapAsSeries(value);
        if (series == null) walk(value);
      }
    });
  }

  // `top-categories`/`growth` return a bare array at the top level (no
  // wrapping object with other stats alongside it) — the other 4 reports
  // return an object, so only the object case walks for standalone numeric
  // stats.
  if (json is List) {
    series = tryListAsSeries(json);
  } else if (json is Map<String, dynamic>) {
    walk(json);
  }
  return AnalyticsReport(stats: stats, series: series ?? const []);
}
