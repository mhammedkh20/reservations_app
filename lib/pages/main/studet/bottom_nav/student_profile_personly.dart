import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:reservations_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:reservations_app/model/user_model.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:reservations_app/widgets/my_contianer_shape.dart';
import 'package:reservations_app/widgets/my_elevated_button.dart';
import 'package:reservations_app/widgets/my_text.dart';
import 'package:reservations_app/widgets/my_text_field.dart';

class StudentProfilePersonly extends StatelessWidget {
  var _keyForm = GlobalKey<FormState>();

  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _numController = TextEditingController();
  late TextEditingController _usernameController = TextEditingController();
  bool loadData = true;

  StudentProfilePersonly({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is LoadingDataUser) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (AuthCubit.get(context).user == null) {
          return Center(
            child: MyText(
                title:
                    AppLocalizations.of(context)!.anErrorOccurredTryAgainLater),
          );
        }
        UserModel? user = AuthCubit.get(context).user;
        if (loadData) {
          AuthCubit.get(context).pathImage = null;

          loadData = false;
          if (user != null) {
            _emailController.text = user.email;
            _usernameController.text = user.username;
            _numController.text = user.number;
          }
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: MyContainerShape(
                    height: 140.r,
                    width: 140.r,
                    enableBorder: true,
                    paddingHorizontal: 5,
                    paddingVertical: 5,
                    borderRadius: 20,
                    widthBorder: 2,
                    colorBorder: AppColors.BASE_COLOR.withOpacity(.5),
                    child: Stack(
                      children: [
                        AuthCubit.get(context).pathImage == null
                            ? user!.urlImage != null
                                ? MyContainerShape(
                                    borderRadius: 20,
                                    child: Image.network(
                                      user.urlImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                : MyContainerShape(
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
                MyText(title: AppLocalizations.of(context)!.universityNo),
                SizedBox(height: 10.h),
                MyTextField(
                    controller: _numController,
                    readOnly: true,
                    filledColor: true,
                    isBorder: true,
                    fillColor2: AppColors.WHITE2,
                    keyboardType: TextInputType.number,
                    textHint: AppLocalizations.of(context)!.universityNo),
                SizedBox(height: 16.h),
                MyText(title: AppLocalizations.of(context)!.email),
                SizedBox(height: 10.h),
                MyTextField(
                  controller: _emailController,
                  filledColor: true,
                  isBorder: true,
                  readOnly: true,
                  fillColor2: AppColors.WHITE2,
                  textHint: AppLocalizations.of(context)!.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
                MyText(title: AppLocalizations.of(context)!.username),
                SizedBox(height: 10.h),
                Form(
                  key: _keyForm,
                  child: MyTextField(
                    controller: _usernameController,
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
                ),
                SizedBox(height: 20.h),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is SuccessUpdateDataUser) {
                      AppHelpers.showSnackBar(
                        context,
                        message: AppLocalizations.of(context)!
                            .operationAccomplishedSuccessfully,
                      );
                    }
                    if (state is FailureUpdateDataUser) {
                      AppHelpers.showSnackBar(
                        context,
                        error: true,
                        message: AppLocalizations.of(context)!
                            .anErrorOccurredPleaseTryAgainLater,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingUpdateDataUser) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return MyElevatedButton(
                      title: AppLocalizations.of(context)!.save,
                      onPressed: () async {
                        if (_keyForm.currentState!.validate()) {
                          AuthCubit.get(context).updateUser(
                            context,
                            username: _usernameController.text.trim(),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
