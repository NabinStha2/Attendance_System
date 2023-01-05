import 'package:attendance_system/core/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      // primarySwatch: Colors.red,
      primaryColor: isDarkTheme ? Colors.black : AColors.kPrimaryColor,
      backgroundColor: isDarkTheme ? Colors.grey.shade800 : AColors.kPrimaryColor,
      indicatorColor: isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
      hintColor: isDarkTheme ? const Color(0xff280C0B) : const Color(0xffEECED3),
      highlightColor: isDarkTheme ? const Color(0xff779EE5) : const Color(0xffFCE192),
      hoverColor: isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
      focusColor: isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.grey.shade900 : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme ? const ColorScheme.dark() : const ColorScheme.light(),
          ),
      iconTheme: IconThemeData(
        color: isDarkTheme ? const Color(0xff779EE5) : AColors.kPrimaryColor,
      ),
      toggleableActiveColor: isDarkTheme ? const Color(0xff779EE5) : AColors.kPrimaryColor,
      appBarTheme: isDarkTheme
          ? AppBarTheme(
              iconTheme: const IconThemeData(color: Colors.white),
              actionsIconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              backgroundColor: Colors.grey.shade900,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.grey[900],
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.light,
              ))
          : const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black87),
              actionsIconTheme: IconThemeData(color: Colors.black87),
              elevation: 0,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              // backgroundColor: AColors.kPrimaryColor,
              backgroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
      fontFamily: GoogleFonts.poppins().fontFamily,
      colorScheme: isDarkTheme
          ? const ColorScheme.dark(
              primary: Color(0xff779EE5),
              secondary: Color(0xff779EE5),
            )
          : const ColorScheme.light(
              primary: AColors.kPrimaryColor,
              secondary: AColors.kPrimaryColor,
            ),
      textButtonTheme: isDarkTheme
          ? TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xff779EE5),
              ),
            )
          : TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AColors.kPrimaryColor,
              ),
            ),
    );
  }
}
