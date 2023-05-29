import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reservations_app/cubits/change_language_cubit/change_language_cubit.dart';
import 'package:reservations_app/cubits/on_boarding_cubit/on_boarding_cubit.dart';
import 'package:reservations_app/pages/auth/sign_in_screen.dart';
import 'package:reservations_app/pages/auth/sign_up_screen.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:reservations_app/widgets/my_contianer_shape.dart';
import 'package:reservations_app/widgets/my_elevated_button.dart';
import 'package:reservations_app/widgets/my_indecators_pageview.dart';
import 'package:reservations_app/widgets/my_page_view.dart';
import 'package:reservations_app/widgets/my_text.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController controller = PageController();
  final PageController controller2 = PageController();
  OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: SizedBox(
              width: double.infinity,
              height: 500.h,
              child: MyPageView(
                controller: controller,
                controller2: controller2,
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: SizedBox(
              width: double.infinity,
              height: 500.h,
              child: MyContainerShape(
                borderRadius: 0,
                topEndRaduis: 300,
                topStartRaduis: 300,
                child: Column(
                  children: [
                    SizedBox(height: 80.h),
                    SizedBox(
                      height: 140,
                      child: PageView.builder(
                        controller: controller2,
                        itemCount: OnBoardingCubit.get(context)
                            .listDataOnBoarding(context)
                            .length,
                        onPageChanged: (int index) {
                          OnBoardingCubit.get(context)
                              .changeIndexPageView(index);
                          controller.animateToPage(index,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: MyText(
                                  title: OnBoardingCubit.get(context)
                                      .listDataOnBoarding(context)[index]
                                      .title,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 55.w),
                                child: MyText(
                                  title: OnBoardingCubit.get(context)
                                      .listDataOnBoarding(context)[index]
                                      .desc,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: AppColors.GRAY,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    const MyIndecatorsPageView(),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26.w),
                      child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyElevatedButton(
                                title: AppLocalizations.of(context)!.getStarted,
                                onPressed: () {
                                  OnBoardingCubit.get(context)
                                      .changeSelectButton(0);

                                  AppHelpers.navigationToPage(
                                      context, const SignUpScreen());
                                },
                                background: OnBoardingCubit.get(context)
                                            .indexSelectedButton ==
                                        0
                                    ? AppColors.BASE_COLOR
                                    : AppColors.TRANSPARENT,
                                titleColor: OnBoardingCubit.get(context)
                                            .indexSelectedButton ==
                                        0
                                    ? AppColors.WHITE
                                    : AppColors.BLACK,
                                borderColor: OnBoardingCubit.get(context)
                                            .indexSelectedButton ==
                                        0
                                    ? AppColors.TRANSPARENT
                                    : AppColors.BORDER,
                              ),
                              SizedBox(height: 30.h),
                              MyElevatedButton(
                                title: AppLocalizations.of(context)!.logIn,
                                onPressed: () {
                                  OnBoardingCubit.get(context)
                                      .changeSelectButton(1);
                                  AppHelpers.navigationToPage(
                                      context, const SignInScreen());
                                },
                                background: OnBoardingCubit.get(context)
                                            .indexSelectedButton ==
                                        1
                                    ? AppColors.BASE_COLOR
                                    : AppColors.TRANSPARENT,
                                titleColor: OnBoardingCubit.get(context)
                                            .indexSelectedButton ==
                                        1
                                    ? AppColors.WHITE
                                    : AppColors.BLACK,
                                borderColor: OnBoardingCubit.get(context)
                                            .indexSelectedButton ==
                                        1
                                    ? AppColors.TRANSPARENT
                                    : AppColors.BORDER,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Material(
                      color: AppColors.WHITE,
                      child:
                          BlocBuilder<ChangeLanguageCubit, ChangeLanguageState>(
                        builder: (context, state) {
                          String lange =
                              ChangeLanguageCubit.get(context).strLanguage;
                          return InkWell(
                            onTap: () {
                              if (lange == 'en') {
                                ChangeLanguageCubit.get(context)
                                    .changeLanguage('ar');
                              } else {
                                ChangeLanguageCubit.get(context)
                                    .changeLanguage('en');
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/ic_language.svg',
                                  width: 24.w,
                                ),
                                SizedBox(width: 10.w),
                                MyText(
                                  title: lange == 'en'
                                      ? AppLocalizations.of(context)!.arabic
                                      : AppLocalizations.of(context)!.english,
                                  color: AppColors.NAVY_BLUE,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
