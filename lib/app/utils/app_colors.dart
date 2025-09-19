// lib/app/utils/app_colors.dart
import 'package:flutter/material.dart';

class CustomColors {
  static bool get isDarkMode => false;
  static const Color player1Color = Color(0xFFE53935);
  static const Color player2Color = Color(0xFF1E88E5);
  static const Color playerXColor = Color(0xFFE53935);
  static const Color playerOColor = Color(0xFF1E88E5);
  static Color get primaryColor =>
      isDarkMode ? _primaryColorDark : _primaryColorLight;
  static Color get container => isDarkMode ? _containerDark : _containerLight;
  static Color get containerPressed =>
      isDarkMode ? _containerPressedDark : _containerPressedLight;
  static Color get containerShadowTop =>
      isDarkMode ? _containerShadowTopDark : _containerShadowTopLight;
  static Color get containerShadowBottom =>
      isDarkMode ? _containerShadowBottomDark : _containerShadowBottomLight;
  static Color get containerInnerShadowTop =>
      isDarkMode ? _containerInnerShadowTopDark : _containerInnerShadowTopLight;
  static Color get containerInnerShadowBottom => isDarkMode
      ? _containerInnerShadowBottomDark
      : _containerInnerShadowBottomLight;
  static Color get primaryTextColor =>
      isDarkMode ? _primaryTextColorDark : _primaryTextColorLight;
  static const Color _primaryColorLight = Color.fromRGBO(235, 240, 243, 1);
  static const Color _primaryColorDark = Color.fromRGBO(32, 35, 41, 1);
  static const Color _containerLight = Color.fromRGBO(241, 245, 248, 1);
  static const Color _containerDark = Color.fromRGBO(40, 50, 54, 1);
  static const Color _containerPressedLight = Color.fromRGBO(232, 235, 241, 1);
  static const Color _containerPressedDark = Color.fromRGBO(45, 50, 54, 1);
  static const Color _containerShadowTopLight = Color.fromARGB(
    220,
    255,
    255,
    255,
  );
  static const Color _containerShadowTopDark = Color.fromRGBO(
    255,
    255,
    255,
    0.1,
  );
  static const Color _containerShadowBottomLight = Color.fromARGB(18, 0, 0, 0);
  static const Color _containerShadowBottomDark = Color.fromRGBO(0, 0, 0, .3);
  static const Color _containerInnerShadowTopLight = Color.fromRGBO(
    204,
    206,
    212,
    1,
  );
  static const Color _containerInnerShadowTopDark = Color.fromRGBO(0, 0, 0, .9);
  static const Color _containerInnerShadowBottomLight = Color.fromRGBO(
    255,
    255,
    255,
    1,
  );
  static const Color _containerInnerShadowBottomDark = Color.fromRGBO(
    49,
    54,
    60,
    1,
  );
  static const Color _primaryTextColorLight = Color.fromRGBO(53, 54, 59, 1);
  static const Color _primaryTextColorDark = Color.fromRGBO(255, 255, 255, 1);
}
