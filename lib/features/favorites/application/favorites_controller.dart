import 'package:flutter_riverpod/flutter_riverpod.dart';

/// In-memory favorite vendor ids so the heart toggle on vendor cards is
/// real and interactive starting from Home. This is intentionally not
/// persisted — Phase 13 (Favorites) replaces this with a repository backed
/// by the real API and local persistence; nothing that reads
/// [favoritesControllerProvider] will need to change when that happens.
class FavoritesController extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void toggle(String vendorId) {
    final next = {...state};
    if (!next.remove(vendorId)) next.add(vendorId);
    state = next;
  }

  bool isFavorite(String vendorId) => state.contains(vendorId);
}

final favoritesControllerProvider = NotifierProvider<FavoritesController, Set<String>>(FavoritesController.new);
