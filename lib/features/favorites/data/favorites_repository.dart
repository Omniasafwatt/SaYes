import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

/// Contract for a customer's favorited vendor ids. The real API is
/// add/remove-by-id, not a bulk replace, so [FavoritesController] calls
/// through one id at a time on every toggle rather than writing the whole
/// set back.
abstract class FavoritesRepository {
  Future<Set<String>> getFavoriteIds();
  Future<void> addFavorite(String vendorId);
  Future<void> removeFavorite(String vendorId);
}

/// Real implementation, backed by `GET/POST/DELETE /users/me/favorites`.
/// The list endpoint's exact item shape isn't pinned down in the API docs
/// (it may return bare vendor ids or full vendor objects) — [getFavoriteIds]
/// handles either so this doesn't break if that ever changes.
class ApiFavoritesRepository implements FavoritesRepository {
  ApiFavoritesRepository(this._api);

  final ApiClient _api;

  @override
  Future<Set<String>> getFavoriteIds() async {
    final data = await _api.get('/users/me/favorites');
    final items = data is List ? data : (data is Map ? data['items'] as List? : null) ?? const [];
    return {
      for (final item in items)
        if (item is String) item else if (item is Map) (item['vendorId'] ?? item['id']) as String,
    };
  }

  @override
  Future<void> addFavorite(String vendorId) async {
    await _api.post('/users/me/favorites/$vendorId');
  }

  @override
  Future<void> removeFavorite(String vendorId) async {
    await _api.delete('/users/me/favorites/$vendorId');
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) => ApiFavoritesRepository(ref.watch(apiClientProvider)));
