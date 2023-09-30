import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../config/router/app_route.dart';
import '../config/themes/app_theme.dart';
import 'common/provider/is_dark_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(isDarkThemeProvider);
    final String publicKey = dotenv.get('PUBLIC_KEY');

    return KhaltiScope(
      publicKey: publicKey,
      builder: (context, navigatorKey) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'),
          ],
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getApplicationTheme(isDarkTheme),
          initialRoute: AppRoute.splashRoute,
          routes: AppRoute.getApplicaionRoute(),
        );
      },
    );
  }
}
