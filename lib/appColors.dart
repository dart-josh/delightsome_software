import 'package:flutter/material.dart';

abstract class AppColors extends BuildContext {
  static const Color dark_primaryBackgroundColor =
      Color.fromARGB(255, 41, 39, 39);
  static const Color light_primaryBackgroundColor = Colors.white;

  // static const Color secondaryBackgroundColor = Color(0xffFFD700);

  static const Color primaryForegroundColor = Colors.green;
  static Color secondaryForegroundColor = Colors.green.shade300;

  static const Color dark_primaryTextColor = Colors.white;
  static const Color light_primaryTextColor = Colors.black;

  static const Color dark_secondaryTextColor = Colors.white54;
  static const Color light_secondaryTextColor = Colors.black54;

  static const Color dark_borderColor = Colors.white24;
  static const Color light_borderColor = Colors.black26;

  static const Color dark_dimTextColor = Colors.white12;
  static const Color light_dimTextColor = Colors.black12;

  static const Color primaryWhiteIconColor = Colors.white;
  static const Color secondaryWhiteIconColor =
      Color.fromARGB(205, 255, 255, 255);

  static const Color dark_dialogBackground_1 = Color.fromARGB(255, 31, 38, 34);
  static const Color dark_dialogBackground_2 = Color.fromARGB(255, 55, 53, 53);
  // light
  static const Color light_dialogBackground_3 =
      Color.fromARGB(255, 236, 235, 214);
  // semi light
  static const Color light_dialogBackground_1 =
      Color.fromARGB(255, 230, 228, 194);
  // dark
  static const Color light_dialogBackground_2 =
      Color.fromARGB(255, 189, 185, 139);

  static Color orange_1 = Colors.orange.shade900;
  static Color orange_2 = Colors.orange.shade900;
}
