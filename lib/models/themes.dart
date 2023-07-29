import 'package:flutter/material.dart';

///# ThemeClass
///
/// With this class the application can access colors for light and dark theme
/// and switch between theme this [lightSwitch] and [darkSwitch] functions.
class ThemeClass {
  Color lightBackgroundColor = const Color(0xFFFAFAFA);
  Color lightPrimaryTextColor = const Color(0xFF212121);
  Color lightSecondaryTextColor = const Color(0xFF757575);
  Color lightDetailTextColor = const Color(0xFF9E9E9E);
  Color lightIconColor = const Color(0xFFFAFAFA);
  Color lightLoadColor = Colors.black;
  Color lightLoadingColor = Colors.white;

  Color darkBackgroundColor = Colors.white10;
  Color darkPrimeryColor = Colors.white;
  Color darkPrimaryTextColor = Colors.white60;
  Color darkSecondaryTextColor = Colors.white12;
  Color darkDetailTextColor = Colors.white24;
  Color darkIconColor = Colors.white60;
  Color darkLoadColor = Colors.white;
  Color darkLoadingColor = Colors.black;
}
