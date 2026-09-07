import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/localization/generated/app_localizations.dart';
import 'core/localization/locale_controller.dart';
import 'core/routing/app_router.dart';
import 'core/session_reset.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const SayYesRoot());
}

/// Rebuilding [ProviderScope] with a fresh key (triggered by [sessionEpoch]
/// changing, on logout) tears down every provider in the tree — including
/// ones with no other reason to reset — so the next signed-in session
/// starts with nothing cached from the last one. See [sessionEpoch] for
/// why this lives above the scope it resets.
class SayYesRoot extends StatelessWidget {
  const SayYesRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: sessionEpoch,
      builder: (context, epoch, _) => ProviderScope(
        key: ValueKey(epoch),
        child: const SayYesApp(),
      ),
    );
  }
}

class SayYesApp extends ConsumerWidget {
  const SayYesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: 'SayYes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(arabic: locale.isArabic),
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter,
    );
  }
}
