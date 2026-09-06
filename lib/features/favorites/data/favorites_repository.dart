import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contract for persisting favorite vendor ids. [FavoritesController] reads
/// this once on startup and writes through it on every toggle.
abstract class FavoritesRepository {
  Future<Set<String>> getFavoriteIds();
  Future<void> setFavoriteIds(Set<String> ids);
}

/// TEMPORARY placeholder implementation — same honest pattern as the other
/// Placeholder repositories: no backend exists yet to sync favorites across
/// a customer's devices, so this only persists on-device via
/// shared_preferences. Replace with a real Dio-backed implementation once
/// the API contract exists; [FavoritesController] won't need to change.
class PlaceholderFavoritesRepository implements FavoritesRepository {
  static const _key = 'sayyes_favorite_vendor_ids';

  @override
  Future<Set<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? const []).toSet();
  }

  @override
  Future<void> setFavoriteIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) => PlaceholderFavoritesRepository());
