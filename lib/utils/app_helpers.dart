import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/widgets/my_text.dart';

class AppHelpers {
  static void navigationReplacementToPage(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static void navigationToPageAndExitAll(BuildContext context, Widget screen) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => false);
  }

  static void navigationToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static showSnackBar(
    BuildContext context, {
    required String message,
    Color? textColor,
    Color? background,
    bool error = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MyText(
          title: message,
          fontSize: 14,
          color: textColor ?? AppColors.WHITE,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: error
            ? Color.fromARGB(255, 132, 33, 13)
            : Color.fromARGB(255, 16, 98, 16),
      ),
    );
  }

  static Map<String, dynamic> getFromAndEndDateTime() {
    DateFormat dateFormat = DateFormat.EEEE('ar');
    DateFormat dateFormat2 = DateFormat.Md('en');
    DateTime now = DateTime.now();
    DateTime? start;
    DateTime? end;

    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      String s = dateFormat.format(date);

      if (i == 0) {
        start = date;
      }
      if (s == 'الجمعة') {
        end = date;
      }
    }
    return {
      'start_date': start,
      'end_date': end,
    };
  }
}
