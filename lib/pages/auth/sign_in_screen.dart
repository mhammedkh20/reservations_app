import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:reservations_app/firestore/fb_auth_controller.dart';
import 'package:reservations_app/firestore/fb_firestore_controller.dart';
import 'package:reservations_app/model/user_model.dart';
import 'package:reservations_app/pages/auth/forget_password_screen.dart';
import 'package:reservations_app/pages/auth/sign_up_screen.dart';
import 'package:reservations_app/pages/main/lecturer/main_lecturer_screen.dart';
import 'package:reservations_app/pages/main/studet/main_studet_screen.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:reservations_app/widgets/my_app_bar.dart';
import 'package:reservations_app/widgets/my_elevated_button.dart';
import 'package:reservations_app/widgets/my_text.dart';
import 'package:reservations_app/widgets/my_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen();
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var _keyForm = GlobalKey<FormState>();

  late TextEditingController textEmail;
  late TextEditingController textPassword;
  bool isLoading = false;

  @override
  void initState() {
    textEmail = TextEditingController();
    textPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEmail.dispose();
    textPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      opacity: .2,
      color: AppColors.BLACK,
      progressIndicator: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.BASE_COLOR),
      ),
      child: Scaffold(
        appBar: MyAppBar(title: AppLocalizations.of(context)!.logIn),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              child: Form(
                key: _keyForm,
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    Image.asset(
                      'assets/images/ic_app.png',
                      width: 110.w,
                      height: 110.h,
                    ),
                    SizedBox(height: 32.h),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: MyText(
                        title: AppLocalizations.of(context)!.welcomeBack,
                        textAlign: TextAlign.end,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: MyText(
                        title: AppLocalizations.of(context)!.logInNow,
                        textAlign: TextAlign.start,
                        color: AppColors.GRAY.withOpacity(.6),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    MyTextField(
                      keyboardType: TextInputType.emailAddress,
                      textHint: AppLocalizations.of(context)!.enterEmail,
                      controller: textEmail,
                      filledColor: true,
                      isBorder: true,
                      fillColor2: AppColors.WHITE2,
                      validator: (String? s) {
                        if (s == null || s.isEmpty) {
                          return AppLocalizations.of(context)!
                              .pleaseFillInTheFieldAbove;
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    MyTextField(
                      keyboardType: TextInputType.text,
                      controller: textPassword,
                      textHint: AppLocalizations.of(context)!.password,
                      maxLines: 1,
                      obscureText: true,
                      filledColor: true,
                      isBorder: true,
                      fillColor2: AppColors.WHITE2,
                      validator: (String? s) {
                        if (s == null || s.isEmpty) {
                          return AppLocalizations.of(context)!
                              .pleaseFillInTheFieldAbove;
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 32.h),
                    MyElevatedButton(
                      title: AppLocalizations.of(context)!.logIn,
                      onPressed: () {
                        if (_keyForm.currentState!.validate()) {
                          preformSignIn();
                        }
                      },
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            AppHelpers.navigationToPage(
                                context, ForgetPasswordScreen());
                          },
                          child: MyText(
                            textAlign: TextAlign.end,
                            title: AppLocalizations.of(context)!.forgotPassword,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            AppHelpers.navigationToPage(
                                context, SignUpScreen());
                          },
                          child: MyText(
                            textAlign: TextAlign.end,
                            title:
                                AppLocalizations.of(context)!.youCanSignUpHere,
                            color: AppColors.GRAY.withOpacity(.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void preformSignIn() async {
    setState(() {
      isLoading = true;
    });
    bool signIn = await FbAuthController()
        .signIn(context, email: textEmail.text, password: textPassword.text);
    if (signIn) {
      QuerySnapshot querySnapshot =
          await FbFirestoreController().getUserFromFirestore(textEmail.text);

      if (querySnapshot.docs[0].exists) {
        QueryDocumentSnapshot queryDocumentSnapshot = querySnapshot.docs[0];
        UserModel user = UserModel.getUserFromDocument(queryDocumentSnapshot);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setBool('islecturer', user.isLecturer);
        await prefs.setString('fcmToken', user.token);
        await prefs.setString('id', user.id);

        // await SharedPrefController().setUser(user);

        setState(() {
          isLoading = false;
        });
        if (user.isLecturer) {
          AppHelpers.navigationToPageAndExitAll(context, MainLecturerScreen());
        } else {
          AppHelpers.navigationToPageAndExitAll(context, MainStudetScreen());
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
