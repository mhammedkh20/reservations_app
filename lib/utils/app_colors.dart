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
  static const Color BASE_COLOR = Color(0xff0f3054);

  static const MaterialColor App_THEME = MaterialColor(
    0xff0f3054,
    <int, Color>{
      50: Color(0xFFC4D1E0),
      100: Color(0xFFA3BFDE),
      200: Color(0xFF79A6D7),
      300: Color(0xFF508ED2),
      400: Color(0xFF357FD0),
      500: Color(0xff2469b4),
      600: Color(0xFF1461B6),
      700: Color(0xFF0E5098),
      800: Color(0xFF0F4D91),
      900: Color(0xFF06386E),
    },
  );
}
