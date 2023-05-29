import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:reservations_app/firestore/fb_auth_controller.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/widgets/my_app_bar.dart';
import 'package:reservations_app/widgets/my_elevated_button.dart';
import 'package:reservations_app/widgets/my_text.dart';
import 'package:reservations_app/widgets/my_text_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController textResetPassword;

  bool isLoading = false;

  @override
  void initState() {
    textResetPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textResetPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context)!.forgotYourPassword),
      body: LoadingOverlay(
        isLoading: isLoading,
        opacity: .2,
        color: AppColors.BLACK,
        progressIndicator: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.BASE_COLOR),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 64.h),
                MyText(
                  title:
                      AppLocalizations.of(context)!.enterEmailhelpFindPassword,
                  textAlign: TextAlign.start,
                  color: AppColors.GRAY.withOpacity(.6),
                ),
                SizedBox(height: 40.h),
                MyTextField(
                  keyboardType: TextInputType.emailAddress,
                  textHint: AppLocalizations.of(context)!.email,
                  filledColor: true,
                  isBorder: true,
                  fillColor2: AppColors.WHITE2,
                  controller: textResetPassword,
                ),
                SizedBox(height: 32.h),
                MyElevatedButton(
                  title: AppLocalizations.of(context)!.checkTheEmail,
                  onPressed: () {
                    preformForgetPassword();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void preformForgetPassword() async {
    setState(() {
      isLoading = true;
    });

    bool success =
        await FbAuthController().passwordReset(context, textResetPassword.text);
    if (success) {
      textResetPassword.text = '';
      Navigator.pop(context);
    }
    setState(() {
      isLoading = false;
    });
  }
}
