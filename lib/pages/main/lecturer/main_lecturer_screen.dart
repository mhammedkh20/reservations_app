import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:reservations_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:reservations_app/cubits/change_language_cubit/change_language_cubit.dart';
import 'package:reservations_app/cubits/main_cubit/main_cubit.dart';
import 'package:reservations_app/pages/auth/sign_in_screen.dart';
import 'package:reservations_app/pages/main/notification_screen.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:reservations_app/utils/notification_api.dart';
import 'package:reservations_app/widgets/bottom_nav_widget.dart';
import 'package:reservations_app/widgets/my_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainLecturerScreen extends StatefulWidget {
  const MainLecturerScreen({super.key});

  @override
  State<MainLecturerScreen> createState() => _MainLecturerScreenState();
}

class _MainLecturerScreenState extends State<MainLecturerScreen> {
  @override
  void initState() {
    AuthCubit.get(context).getDataUserLecturer(context);
    NotificationApi.init();
    NotificationApi.requestIOSPermissions();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        if (notification.title != null) {
          NotificationApi.showNotification(
            id: notification.hashCode,
            title: notification.title ?? "",
            body: notification.body ?? "",
            urlImage: notification.android == null
                ? null
                : notification.android!.imageUrl,
            // payload: 'mohammed',
          );
        }
      }
    });
    FirebaseMessaging.instance.subscribeToTopic("all_users");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            int indexSelected = MainCubit.get(context).page;
            return MyText(
              title: MainCubit.get(context)
                  .itemsLecturer(context)[indexSelected]
                  .title,
              color: AppColors.WHITE,
              textAlign: TextAlign.center,
            );
          },
        ),
        leading: BlocBuilder<ChangeLanguageCubit, ChangeLanguageState>(
          builder: (context, state) {
            String lang = ChangeLanguageCubit.get(context).strLanguage;
            return Row(
              children: [
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    if (lang == 'en') {
                      ChangeLanguageCubit.get(context).changeLanguage('ar');
                    } else {
                      ChangeLanguageCubit.get(context).changeLanguage('en');
                    }
                  },
                  child: MyText(
                    title: lang == 'en' ? 'Ar' : 'En',
                    color: AppColors.WHITE,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String key) async {
              switch (key) {
                case 'notification':
                  AppHelpers.navigationToPage(context, NotificationScreen());

                  break;

                case 'logout':
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.clear();
                  AppHelpers.navigationToPageAndExitAll(
                      context, SignInScreen());
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: MyText(
                      title: AppLocalizations.of(context)!.notifications),
                  value: "notification",
                ),
                PopupMenuItem(
                  child: MyText(title: AppLocalizations.of(context)!.logout),
                  value: "logout",
                ),
              ];
            },
          ),
        ],
      ),
      body: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          int indexSelected = MainCubit.get(context).page;

          return MainCubit.get(context)
              .itemsLecturer(context)[indexSelected]
              .widget;
        },
      ),
      bottomNavigationBar: BottomNavWidget(),
    );
  }
}
    //  Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: const [
    //           Icon(
    //             Icons.notifications,
    //             color: AppColors.WHITE,
    //           ),
    //         ],
    //       ),
    //       SizedBox(width: 16.w),