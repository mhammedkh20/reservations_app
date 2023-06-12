import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:reservations_app/cubits/change_language_cubit/change_language_cubit.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/model/custom_class_date.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_dialogs.dart';
import 'package:reservations_app/widgets/my_contianer_shape.dart';
import 'package:reservations_app/widgets/my_elevated_button.dart';
import 'package:reservations_app/widgets/my_text.dart';

class AddAppointments extends StatefulWidget {
  const AddAppointments({super.key});

  @override
  State<AddAppointments> createState() => _AddAppointmentsState();
}

class _AddAppointmentsState extends State<AddAppointments> {
  @override
  void initState() {
    if (mounted) {
      StudentAppointmentsCubit.get(context).getSevenDay(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            MyText(
              title: AppLocalizations.of(context)!.reservationDates,
              color: AppColors.GRAY,
            ),
            SizedBox(height: 20.h),
            myTable(),
          ],
        ),
      ),
    );
  }

  Widget myTable() {
    DateFormat dateFormat2 = DateFormat.Hm('en');

    return BlocBuilder<ChangeLanguageCubit, ChangeLanguageState>(
      builder: (context, state) {
        bool langAr = ChangeLanguageCubit.get(context).strLanguage == 'ar';
        return BlocBuilder<StudentAppointmentsCubit, StudentAppointmentsState>(
          builder: (context, state) {
            List<CustomClassDate> nextSevenDays =
                StudentAppointmentsCubit.get(context).allDate;
            return Column(
              children: [
                Row(
                  children: [
                    for (int i = 0; i < nextSevenDays.length; i++)
                      Expanded(
                        child: MyContainerShape(
                          enableBorder: true,
                          paddingVertical: 5,
                          borderRadius: 0,
                          child: MyText(
                            title: langAr
                                ? nextSevenDays[i].dayOfWeekAr +
                                    "\n" +
                                    nextSevenDays[i].todayDate
                                : nextSevenDays[i].dayOfWeekEn +
                                    "\n" +
                                    nextSevenDays[i].todayDate,
                            textAlign: TextAlign.center,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < nextSevenDays.length; i++)
                      Expanded(
                        child: MyContainerShape(
                          enableBorder: true,
                          paddingVertical: 5,
                          borderRadius: 0,
                          child: Column(
                            children: [
                              SizedBox(height: 10.h),
                              ListView.builder(
                                itemCount: nextSevenDays[i].listAppo.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MyContainerShape(
                                    marginBottom: 10,
                                    marginEnd: 5,
                                    marginStart: 5,
                                    paddingVertical: 4,
                                    borderRadius: 4,
                                    enableShadow: false,
                                    bgContainer: nextSevenDays[i]
                                                .listAppo[index]
                                                .student !=
                                            null
                                        ? AppColors.RED.withOpacity(.2)
                                        : AppColors.GREEN.withOpacity(.2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: nextSevenDays[i]
                                                      .listAppo[index]
                                                      .student !=
                                                  null
                                              ? null
                                              : () {
                                                  StudentAppointmentsCubit.get(
                                                          context)
                                                      .deletePeriod(
                                                    indexDay: i,
                                                    indexPeriod: index,
                                                  );
                                                },
                                          child: Icon(
                                            Icons.close,
                                            size: 18.r,
                                          ),
                                        ),
                                        MyText(
                                          fontSize: 14,
                                          textAlign: TextAlign.center,
                                          title:
                                              '${dateFormat2.format(nextSevenDays[i].listAppo[index].fromTime!)}\n${dateFormat2.format(nextSevenDays[i].listAppo[index].toTime!)}',
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  AppDialogs.addAppointmentDialog(context,
                                      index: i);
                                },
                                child: SvgPicture.asset(
                                    'assets/images/ic_add.svg'),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
