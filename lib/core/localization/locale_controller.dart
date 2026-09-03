import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const supportedLocales = [Locale('en'), Locale('ar')];

const _prefsKey = 'sayyes_locale_code';

extension LocaleX on Locale {
  bool get isArabic => languageCode == 'ar';
}

/// Holds the active app language and persists the choice locally.
/// Everything reactive to language (theme font family, text direction,
/// translated strings) reads from this single source of truth.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    _restorePersisted();
    return const Locale('en');
  }

  Future<void> _restorePersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && supportedLocales.any((l) => l.languageCode == saved)) {
      state = Locale(saved);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }

  Future<void> toggle() => setLocale(state.isArabic ? const Locale('en') : const Locale('ar'));
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(LocaleController.new);
