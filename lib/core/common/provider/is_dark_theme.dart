import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared_prefs/auth_theme_prefs.dart';

final isDarkThemeProvider = StateNotifierProvider<IsDarkTheme, bool>(
  (ref) => IsDarkTheme(
    ref.watch(appThemePrefsProvider),
  ),
);

class IsDarkTheme extends StateNotifier<bool> {
  final AppThemePrefs appThemePrefs;

  // initialliy it will be light theme
  IsDarkTheme(this.appThemePrefs) : super(false) {
    onInit();
  }

  onInit() async {
    final isDarkTheme = await appThemePrefs.getTheme();
    isDarkTheme.fold((l) => state = false, (r) => state = r);
  }

  updateTheme(bool isDarkTheme) {
    appThemePrefs.setTheme(isDarkTheme);
    state = isDarkTheme;
  }
}
