import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservations_app/cubits/main_cubit/main_cubit.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/widgets/item_bottom_nav.dart';

class BottomNavStudetWidget extends StatelessWidget {
  const BottomNavStudetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.WHITE2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<MainCubit, MainState>(
            builder: (context, state) {
              int indexSelected = MainCubit.get(context).page;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 50.h),
                  ItemBottomNav(
                    title: MainCubit.get(context).itemsStudet(context)[0].title,
                    onTap: () {
                      MainCubit.get(context).changeIndexPage(0);
                    },
                    isSelected: indexSelected == 0,
                  ),
                  ItemBottomNav(
                    title: MainCubit.get(context).itemsStudet(context)[1].title,
                    onTap: () {
                      MainCubit.get(context).changeIndexPage(1);
                    },
                    isSelected: indexSelected == 1,
                  ),
                  ItemBottomNav(
                    title: MainCubit.get(context).itemsStudet(context)[2].title,
                    onTap: () {
                      MainCubit.get(context).changeIndexPage(2);
                    },
                    isSelected: indexSelected == 2,
                  ),
                  ItemBottomNav(
                    title: MainCubit.get(context).itemsStudet(context)[3].title,
                    onTap: () {
                      MainCubit.get(context).changeIndexPage(3);
                    },
                    isSelected: indexSelected == 3,
                  ),
                  SizedBox(height: 50.h),
                ],
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
