import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kRecentSearchesKey = 'sayyes_recent_searches';
const _kMaxRecentSearches = 8;

/// Locally persisted recent search queries, most-recent-first, deduped and
/// capped. Not backend-synced — this is purely a per-device convenience,
/// unlike Favorites/Bookings which will be server-owned.
class RecentSearchesService {
  Future<List<String>> read() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kRecentSearchesKey) ?? const [];
  }

  Future<void> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final current = (prefs.getStringList(_kRecentSearchesKey) ?? const [])
        .where((q) => q.toLowerCase() != trimmed.toLowerCase())
        .toList()
      ..insert(0, trimmed);
    await prefs.setStringList(_kRecentSearchesKey, current.take(_kMaxRecentSearches).toList());
  }

  Future<void> remove(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final current = (prefs.getStringList(_kRecentSearchesKey) ?? const []).where((q) => q != query).toList();
    await prefs.setStringList(_kRecentSearchesKey, current);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kRecentSearchesKey);
  }
}

final recentSearchesServiceProvider = Provider<RecentSearchesService>((ref) => RecentSearchesService());
