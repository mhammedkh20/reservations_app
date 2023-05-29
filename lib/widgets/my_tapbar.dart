import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/widgets/my_contianer_shape.dart';
import 'package:reservations_app/widgets/my_text.dart';

class MyTapBar extends StatelessWidget {
  const MyTapBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyContainerShape(
      height: 50.h,
      borderRadius: 40,
      enableShadow: false,
      paddingHorizontal: 10,
      bgContainer: AppColors.BASE_COLOR.withOpacity(.2),
      child: BlocBuilder<StudentAppointmentsCubit, StudentAppointmentsState>(
        builder: (context, state) {
          int index = StudentAppointmentsCubit.get(context).indexTapBar;
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    StudentAppointmentsCubit.get(context)
                        .changeIndexTapBar(0, context);
                  },
                  child: MyContainerShape(
                    height: 40.h,
                    bgContainer: index == 0
                        ? AppColors.BASE_COLOR
                        : AppColors.TRANSPARENT,
                    child: MyText(
                      title: AppLocalizations.of(context)!.pending,
                      color: index == 0 ? AppColors.WHITE : AppColors.BLACK,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    StudentAppointmentsCubit.get(context)
                        .changeIndexTapBar(1, context);
                  },
                  child: MyContainerShape(
                    height: 40.h,
                    bgContainer: index == 1
                        ? AppColors.BASE_COLOR
                        : AppColors.TRANSPARENT,
                    child: MyText(
                      title: AppLocalizations.of(context)!.underway,
                      fontSize: 14,
                      color: index == 1 ? AppColors.WHITE : AppColors.BLACK,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    StudentAppointmentsCubit.get(context)
                        .changeIndexTapBar(2, context);
                  },
                  child: MyContainerShape(
                    height: 40.h,
                    bgContainer: index == 2
                        ? AppColors.BASE_COLOR
                        : AppColors.TRANSPARENT,
                    child: MyText(
                      fontSize: 14,
                      title: AppLocalizations.of(context)!.ended,
                      color: index == 2 ? AppColors.WHITE : AppColors.BLACK,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
