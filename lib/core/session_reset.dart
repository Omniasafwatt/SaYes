import 'package:flutter/foundation.dart';

/// Bump this after logout to force a full Riverpod provider-tree reset
/// (see main.dart's [ValueListenableBuilder] around [ProviderScope]).
///
/// Without it, every AsyncNotifier/Notifier that caches a signed-in
/// account's data — profile, notifications, favorites, customer bookings,
/// vendor bookings, vendor dashboard — stays alive in memory across
/// logout, so logging into a *different* account in the same running app
/// process would show the previous account's cached state until the app
/// is force-closed. Bumping this lives outside Riverpod on purpose: the
/// mechanism that resets providers can't itself be a provider that gets
/// reset.
final sessionEpoch = ValueNotifier<int>(0);
