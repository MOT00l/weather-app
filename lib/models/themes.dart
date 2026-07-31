import 'package:flutter/material.dart';

///# ThemeClass
///
/// With this class the application can access colors for light and dark theme
/// and switch between theme this [lightSwitch] and [darkSwitch] functions.
class ThemeClass {
  Color lightBackgroundColor = const Color(0xFFEEF1F4);
  Color lightPrimaryTextColor = const Color(0xFF212121);
  Color lightSecondaryTextColor = const Color(0xFF757575);
  Color lightDetailTextColor = const Color(0xFF9E9E9E);
  Color lightIconColor = Colors.black;
  Color lightLoadColor = Colors.black;
  Color lightLoadingColor = Colors.white;
  Color lightTextColor = Colors.black.withValues(alpha: 0.3);
  Color lightGlassColor = Colors.white;
  Color lightGradientOne = Color(0xFFFDFDFD);
  Color lightGradientTwo = Color(0xFFF5F5F7);
  Color lightGradientThree = Color(0xFFEDEEF1);

  Color darkBackgroundColor = Colors.black;
  Color darkPrimaryColor = Colors.white;
  Color darkPrimaryTextColor = Colors.white60;
  Color darkSecondaryTextColor = Colors.white12;
  Color darkDetailTextColor = Colors.white24;
  Color darkIconColor = const Color(0xFFFAFAFA);
  Color darkLoadColor = Colors.white;
  Color darkLoadingColor = Colors.black;
  Color darkTextColor = Colors.white.withValues(alpha: 0.3);
  Color darkGlassColor = Colors.black;
  Color darkGradientOne = Color(0xFF121212);
  Color darkGradientTwo = Color(0xFF080808);
  Color darkGradientThree = Color(0xFF000000);
}
