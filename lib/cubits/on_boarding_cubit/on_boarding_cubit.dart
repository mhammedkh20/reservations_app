import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservations_app/model/onboarding_model.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  List<OnBoardingModel> listDataOnBoarding(BuildContext context) {
    return [
      OnBoardingModel(
        imagePath: 'assets/images/im1.png',
        title: AppLocalizations.of(context)!.titleOnboarding1,
        desc: AppLocalizations.of(context)!.descOnboarding1,
      ),
      OnBoardingModel(
        imagePath: 'assets/images/im2.png',
        title: AppLocalizations.of(context)!.titleOnboarding2,
        desc: AppLocalizations.of(context)!.descOnboarding2,
      ),
      OnBoardingModel(
        imagePath: 'assets/images/im3.png',
        title: AppLocalizations.of(context)!.titleOnboarding3,
        desc: AppLocalizations.of(context)!.descOnboarding3,
      ),
    ];
  }

  OnBoardingCubit() : super(OnBoardingInitial());

  static OnBoardingCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  int indexListOnBoarding = 0;
  changeIndexPageView(int index) {
    indexListOnBoarding = index;
    emit(OnBoardingInitial());
    // setState(() {});
  }

  int indexSelectedButton = 0;
  changeSelectButton(int index) {
    indexSelectedButton = index;
    emit(OnBoardingInitial());
  }
}
