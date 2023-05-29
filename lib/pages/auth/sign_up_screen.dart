import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:reservations_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:reservations_app/firestore/fb_auth_controller.dart';
import 'package:reservations_app/firestore/fb_firestore_controller.dart';
import 'package:reservations_app/firestore/fb_storage_controller.dart';
import 'package:reservations_app/model/user_model.dart';
import 'package:reservations_app/pages/auth/send_verification_screen.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:reservations_app/widgets/item_radio.dart';
import 'package:reservations_app/widgets/my_app_bar.dart';
import 'package:reservations_app/widgets/my_contianer_shape.dart';
import 'package:reservations_app/widgets/my_elevated_button.dart';
import 'package:reservations_app/widgets/my_text.dart';
import 'package:reservations_app/widgets/my_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen();
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _keyForm = GlobalKey<FormState>();

  bool isLoading = false;
  int isTeacher = 1;
  bool switchOwner = false;

  TextEditingController textUsername = TextEditingController();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textUniversityNo = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  TextEditingController textPasswordConfirm = TextEditingController();

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
        appBar: MyAppBar(title: AppLocalizations.of(context)!.getStarted),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Form(
              key: _keyForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  Align(
                    alignment: Alignment.center,
                    child: MyContainerShape(
                      height: 140.r,
                      width: 140.r,
                      enableBorder: true,
                      paddingHorizontal: 5,
                      paddingVertical: 5,
                      borderRadius: 20,
                      widthBorder: 3,
                      colorBorder: AppColors.BASE_COLOR.withOpacity(.5),
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return Stack(
                            children: [
                              AuthCubit.get(context).pathImage == null
                                  ? MyContainerShape(
                                      borderRadius: 20,
                                      child: Icon(
                                        Icons.person,
                                        size: 40.r,
                                      ),
                                    )
                                  : MyContainerShape(
                                      borderRadius: 20,
                                      child: Image.file(
                                        File(AuthCubit.get(context).pathImage!),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () async {
                        await AuthCubit.get(context).pickImageUser();
                      },
                      child: MyText(
                        title: AppLocalizations.of(context)!.addImage,
                        color: AppColors.BASE_COLOR,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  MyTextField(
                    filledColor: true,
                    isBorder: true,
                    fillColor2: AppColors.WHITE2,
                    controller: textUniversityNo,
                    keyboardType: TextInputType.emailAddress,
                    textHint: isTeacher == 1
                        ? AppLocalizations.of(context)!.jobID
                        : AppLocalizations.of(context)!.universityNo,
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
                    controller: textUsername,
                    filledColor: true,
                    isBorder: true,
                    fillColor2: AppColors.WHITE2,
                    keyboardType: TextInputType.text,
                    textHint: AppLocalizations.of(context)!.username,
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
                    controller: textEmail,
                    filledColor: true,
                    isBorder: true,
                    fillColor2: AppColors.WHITE2,
                    textHint: AppLocalizations.of(context)!.enterEmail,
                    validator: (String? s) {
                      if (s == null || s.isEmpty) {
                        return AppLocalizations.of(context)!
                            .pleaseFillInTheFieldAbove;
                      }

                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.h),
                  MyTextField(
                    controller: textPassword,
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
                    keyboardType: TextInputType.text,
                    textHint: AppLocalizations.of(context)!.password,
                    maxLines: 1,
                    obscureText: true,
                  ),
                  SizedBox(height: 16.h),
                  MyTextField(
                    maxLines: 1,
                    controller: textPasswordConfirm,
                    filledColor: true,
                    isBorder: true,
                    fillColor2: AppColors.WHITE2,
                    keyboardType: TextInputType.text,
                    textHint: AppLocalizations.of(context)!.confirmPassword,
                    validator: (String? s) {
                      if (s == null || s.isEmpty) {
                        return AppLocalizations.of(context)!
                            .pleaseFillInTheFieldAbove;
                      }

                      if (textPasswordConfirm.text != textPassword.text) {
                        return AppLocalizations.of(context)!
                            .checkTwoPasswordsTheSame;
                      }

                      return null;
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      MyText(
                          title:
                              '${AppLocalizations.of(context)!.userType} : '),
                      ItemRadio(
                        title: AppLocalizations.of(context)!.lecturer,
                        onChanged: (int? enabled) {
                          isTeacher = 1;
                          setState(() {});
                        },
                        value: isTeacher,
                        indexKey: 1,
                      ),
                      SizedBox(width: 16.w),
                      ItemRadio(
                        title: AppLocalizations.of(context)!.student,
                        onChanged: (int? enabled) {
                          isTeacher = 2;
                          setState(() {});
                        },
                        value: isTeacher,
                        indexKey: 2,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  MyElevatedButton(
                    title: AppLocalizations.of(context)!.getStarted,
                    onPressed: () {
                      if (_keyForm.currentState!.validate()) {
                        preformSignUp(context);
                      }
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void preformSignUp(BuildContext context) async {
    if (AuthCubit.get(context).pathImage == null) {
      AppHelpers.showSnackBar(
        context,
        message: AppLocalizations.of(context)!.personalPhotoRequired,
        error: true,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    String token = (await FbAuthController().getToken())!;

    UserCredential? userCredential = await FbAuthController().createAccount(
        context,
        email: textEmail.text,
        password: textPassword.text);

    if (userCredential != null) {
      setState(() {
        isLoading = false;
      });

      await FbFirestoreController().createUser(user: await user(token));

      AppHelpers.navigationToPage(
        context,
        SendVerificationScreen(userCredential: userCredential),
      );
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<UserModel> user(String token) async {
    String urlImage = await FbStorageController().uploadImage(
      XFile(AuthCubit.get(context).pathImage!),
    );
    AuthCubit.get(context).pathImage = null;
    String id = FirebaseFirestore.instance.collection('users').doc().id;

    return UserModel(
      id: id,
      number: textUniversityNo.text,
      username: textUsername.text,
      email: textEmail.text,
      password: textPassword.text,
      token: token,
      urlImage: urlImage,
      isLecturer: isTeacher == 1,
    );
  }
}
