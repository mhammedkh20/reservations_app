import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservations_app/cubits/on_boarding_cubit/on_boarding_cubit.dart';

class MyPageView extends StatelessWidget {
  final PageController controller;
  final PageController controller2;
  const MyPageView({
    Key? key,
    required this.controller,
    required this.controller2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount:
          OnBoardingCubit.get(context).listDataOnBoarding(context).length,
      onPageChanged: (int index) {
        OnBoardingCubit.get(context).changeIndexPageView(index);
        controller2.animateToPage(index,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      },
      itemBuilder: (context, index) {
        return Image.asset(
          OnBoardingCubit.get(context)
              .listDataOnBoarding(context)[index]
              .imagePath,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
