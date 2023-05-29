import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservations_app/cubits/on_boarding_cubit/on_boarding_cubit.dart';
import 'package:reservations_app/widgets/indecator.dart';

class MyIndecatorsPageView extends StatelessWidget {
  const MyIndecatorsPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Indecatior(
                selected:
                    OnBoardingCubit.get(context).indexListOnBoarding == 0),
            SizedBox(width: 5.w),
            Indecatior(
                selected:
                    OnBoardingCubit.get(context).indexListOnBoarding == 1),
            SizedBox(width: 5.w),
            Indecatior(
                selected:
                    OnBoardingCubit.get(context).indexListOnBoarding == 2),
          ],
        );
      },
    );
  }
}
