import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:reservations_app/firestore/fb_auth_controller.dart';
import 'package:reservations_app/main.dart';
import 'package:reservations_app/pages/auth/sign_in_screen.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:reservations_app/widgets/my_app_bar.dart';
import 'package:reservations_app/widgets/my_text.dart';

class SendVerificationScreen extends StatefulWidget {
  late UserCredential userCredential;

  SendVerificationScreen({required this.userCredential});

  @override
  _SendVerificationScreenState createState() => _SendVerificationScreenState();
}

class _SendVerificationScreenState extends State<SendVerificationScreen> {
  bool isLoading = false;

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
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.checkTheEmail,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: MyText(
                  title: 'ارسل رسالة تحقق الى البريد الالكتروني',
                  color: AppColors.WHITE,
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  bool checkValidate = await FbAuthController()
                      .handleEmailValidation(context, widget.userCredential);
                  if (!checkValidate) {
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                      context: context,
                      barrierColor: AppColors.BLACK.withOpacity(.1),
                      builder: (context) {
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context);
                          AppHelpers.navigationToPageAndExitAll(
                              context, SignInScreen());
                        });
                        return animatedCongratulation();
                      },
                      barrierDismissible: true,
                    );
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog animatedCongratulation() {
    return AlertDialog(
      backgroundColor: AppColors.TRANSPARENT,
      elevation: 0,
      content:
          Lottie.asset('assets/images/congratulation1.json', repeat: false),
    );
  }
}
