import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/favorites_repository.dart';

/// Favorite vendor ids, restored from [FavoritesRepository] on startup and
/// written through on every toggle — so the heart on any vendor card stays
/// correct across app restarts. Read by every card/detail screen that shows
/// a favorite toggle; none of them need to change when this repository
/// swaps to a real backend-synced implementation.
class FavoritesController extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    _restorePersisted();
    return <String>{};
  }

  Future<void> _restorePersisted() async {
    final ids = await ref.read(favoritesRepositoryProvider).getFavoriteIds();
    state = ids;
  }

  void toggle(String vendorId) {
    final repository = ref.read(favoritesRepositoryProvider);
    final wasFavorite = state.contains(vendorId);
    final next = {...state};
    if (wasFavorite) {
      next.remove(vendorId);
    } else {
      next.add(vendorId);
    }
    state = next;

    final future = wasFavorite ? repository.removeFavorite(vendorId) : repository.addFavorite(vendorId);
    future.catchError((Object _) {
      // Roll back on failure so the heart icon never lies about server state.
      final reverted = {...state};
      if (wasFavorite) {
        reverted.add(vendorId);
      } else {
        reverted.remove(vendorId);
      }
      state = reverted;
    });
  }

  bool isFavorite(String vendorId) => state.contains(vendorId);
}

final favoritesControllerProvider = NotifierProvider<FavoritesController, Set<String>>(FavoritesController.new);
