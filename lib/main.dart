import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservations_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:reservations_app/cubits/change_language_cubit/change_language_cubit.dart';
import 'package:reservations_app/cubits/main_cubit/main_cubit.dart';
import 'package:reservations_app/cubits/on_boarding_cubit/on_boarding_cubit.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/firebase_options.dart';
import 'package:reservations_app/pages/on_boarding/launch_screen.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/notification_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationApi().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => OnBoardingCubit()),
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => ChangeLanguageCubit()),
            BlocProvider(create: (context) => MainCubit()),
            BlocProvider(create: (context) => StudentAppointmentsCubit()),
          ],
          child: BlocBuilder<ChangeLanguageCubit, ChangeLanguageState>(
            builder: (context, state) {
              String lang = ChangeLanguageCubit.get(context).strLanguage;

              return MaterialApp(
                title: 'زميل الدراسة',
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                locale: Locale(lang),
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                ],
                theme: ThemeData(
                  primarySwatch: AppColors.App_THEME,
                  scaffoldBackgroundColor: AppColors.WHITE,
                ),
                home: const LaunchScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
