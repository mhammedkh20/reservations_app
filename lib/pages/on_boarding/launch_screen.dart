import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservations_app/firestore/fb_auth_controller.dart';
import 'package:reservations_app/pages/main/lecturer/main_lecturer_screen.dart';
import 'package:reservations_app/pages/main/studet/main_studet_screen.dart';
import 'package:reservations_app/pages/on_boarding/on_boarding_screen.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:reservations_app/widgets/my_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String? id = prefs.getString('id');
      bool? islecturer = prefs.getBool('islecturer');
      if (id == null) {
        AppHelpers.navigationReplacementToPage(context, OnBoardingScreen());
      } else {
        if (islecturer!) {
          AppHelpers.navigationReplacementToPage(context, MainLecturerScreen());
        } else {
          AppHelpers.navigationReplacementToPage(context, MainStudetScreen());
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ic_app.png',
            width: 180.w,
          ),
          SizedBox(
            height: 20.h,
            width: double.infinity,
          ),
          MyText(title: 'ASUBooking')
        ],
      ),
    );
  }
}
