// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppColors {
  static const Color WHITE = Color(0xffFFFFFF);
  static const Color WHITE2 = Color(0xffFAFAFA);
  static const Color WHITE3 = Color(0xffF3F3F3);

  static const Color TRANSPARENT = Color.fromARGB(0, 250, 250, 250);
  static const Color BLACK = Color(0xff353535);
  static const Color BLACK0 = Color.fromARGB(255, 0, 0, 0);

  static const Color RED = Color(0xffF73D17);
  static const Color NAVY_BLUE = Color(0xff0473C0);
  static const Color GREEN = Color(0xff4CAF50);
  static const Color GRAY = Color(0xff717171);
  static const Color GRAY2 = Color.fromARGB(184, 113, 113, 113);

  static const Color BG_MESSAGE = Color(0xffBEDCF6);

  static const Color BORDER = Color(0xffDFE0DF);

  static const Color pink = Color(0xFFFF4550);
  static Color pink100 = pink.withOpacity(.1);
  static Color pink300 = pink.withOpacity(.3);
  static Color pink400 = pink.withOpacity(.4);
  static const Color BASE_COLOR = Color(0xff0473C0);

  // static const MaterialColor App_THEME = MaterialColor(
  //   0xffD91A2E,
  //   <int, Color>{
  //     50: Color(0xFFECD1D4),
  //     100: Color(0xFFEEB1B7),
  //     200: Color(0xFFE8858F),
  //     300: Color(0xFFE35968),
  //     400: Color(0xFFE03B4C),
  //     500: Color(0xffc92b3c),
  //     600: Color(0xFFC91729),
  //     700: Color(0xFFAD1122),
  //     800: Color(0xFFA61120),
  //     900: Color(0xFF830916),
  //   },
  // );

  static const MaterialColor App_THEME = MaterialColor(
    0xff0473C0,
    <int, Color>{
      50: Color(0xFFCEDDE8),
      100: Color(0xFFACD0E8),
      200: Color(0xFF82BBE3),
      300: Color(0xFF56A5DC),
      400: Color(0xFF3897D9),
      500: Color(0xff2883c2),
      600: Color(0xFF167CC4),
      700: Color(0xFF1069A8),
      800: Color(0xFF11659F),
      900: Color(0xFF084D7C),
    },
  );
}
