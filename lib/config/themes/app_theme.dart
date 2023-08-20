import 'package:flutter/material.dart';

import '../constants/theme_constant.dart';
import 'app_color_constant.dart';

class AppTheme {
  AppTheme._();

  static getApplicationTheme(bool isDark) {
    return ThemeData(
      colorScheme: isDark
          ? const ColorScheme.dark(
              primary: ThemeConstant.darkPrimaryColor,
            )
          : const ColorScheme.light(
              primary: ThemeConstant.primaryColor,
            ),
      brightness: isDark ? Brightness.dark : Brightness.light,

      // colorScheme: const ColorScheme.light(background: Colors.amber),
      scaffoldBackgroundColor: isDark
          ? AppColorConstant.nightScafoldBackgroundColor
          : AppColorConstant.dayScafoldBackgroundColor,

      // theme for input decoration
      // inputDecorationTheme: InputDecorationTheme(
      //   labelStyle: const TextStyle(
      //     color: Colors.black, // Set the label text color
      //   ),
      //   hintStyle: const TextStyle(
      //     color: Colors.black, // Set the hint text color
      //   ),
      //   filled: true,
      //   prefixIconColor: Colors.white,
      //   suffixIconColor: Colors.white,
      //   fillColor: Colors.white, // Set the background color
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(10.0),
      //   ),
      //   counterStyle: const TextStyle(
      //     color: Colors.yellow, // Set the counter text color
      //   ),
      // ),

      inputDecorationTheme: InputDecorationTheme(
          // labelStyle: TextStyle(color: isDark ? Colors.black : Colors.white),
          labelStyle: const TextStyle(color: Colors.black),
          // hintStyle: TextStyle(
          //   color: isDark ? Colors.black : const Color(0xFF766A6A),
          // ),
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
          prefixIconColor: Colors.white,
          suffixIconColor: Colors.white,
          filled: true,
          fillColor: isDark
              ? AppColorConstant.nightInputBackgroundColor
              : AppColorConstant.dayInputBackgroundColor, // dark : light
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          counterStyle: const TextStyle(color: Colors.yellow)),

      // theme for elevated button

      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF705CEF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 12.0,
              shadowColor: const Color.fromARGB(255, 206, 203, 203))),

      // theme for divider
      dividerTheme: DividerThemeData(
        thickness: 2.0,
        color: isDark ? Colors.white : Colors.black,
      ),

      // theme for snackbar
      snackBarTheme: const SnackBarThemeData(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
