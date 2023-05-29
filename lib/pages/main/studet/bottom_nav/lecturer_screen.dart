import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/model/custom_class_date.dart';
import 'package:reservations_app/model/user_model.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_dialogs.dart';
import 'package:reservations_app/widgets/my_app_bar.dart';
import 'package:reservations_app/widgets/my_contianer_shape.dart';
import 'package:reservations_app/widgets/my_elevated_button.dart';
import 'package:reservations_app/widgets/my_text.dart';

class LecturerScreen extends StatefulWidget {
  final UserModel lecturer;
  const LecturerScreen({
    super.key,
    required this.lecturer,
  });

  @override
  State<LecturerScreen> createState() => _LecturerScreenState();
}

class _LecturerScreenState extends State<LecturerScreen> {
  @override
  void initState() {
    StudentAppointmentsCubit.get(context)
        .getSevenDay(context, lecturerId: widget.lecturer.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.lecturer.username),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Align(
                child: MyContainerShape(
                  borderRadius: 20,
                  height: 110.r,
                  width: 110.r,
                  enableBorder: true,
                  colorBorder: AppColors.BASE_COLOR,
                  child: widget.lecturer.urlImage != null
                      ? Image.network(
                          widget.lecturer.urlImage!,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
                          size: 30.r,
                          color: AppColors.GRAY,
                        ),
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                child: MyText(title: widget.lecturer.username),
              ),
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
      ),
    );
  }

  Widget myTable() {
    DateFormat dateFormat2 = DateFormat.Hm('en');

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
                        title: nextSevenDays[i].dayOfWeek +
                            "\n" +
                            nextSevenDays[i].todayDate,
                        textAlign: TextAlign.center,
                        fontSize: 14,
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
                            padding: EdgeInsets.zero,
                            itemCount: nextSevenDays[i].listAppo.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap:
                                    nextSevenDays[i].listAppo[index].student !=
                                            null
                                        ? null
                                        : () {
                                            AppDialogs.reservationRequestDialog(
                                              context,
                                              fromTime: nextSevenDays[i]
                                                  .listAppo[index]
                                                  .fromTime!,
                                              toTime: nextSevenDays[i]
                                                  .listAppo[index]
                                                  .toTime!,
                                              indexDay: i,
                                              indexAppo: index,
                                              idAppo: nextSevenDays[i]
                                                  .listAppo[index]
                                                  .id!,
                                            );
                                          },
                                child: MyContainerShape(
                                  marginBottom: 10,
                                  marginEnd: 8,
                                  marginStart: 8,
                                  paddingVertical: 4,
                                  borderRadius: 4,
                                  enableShadow: false,
                                  bgContainer: nextSevenDays[i]
                                              .listAppo[index]
                                              .student ==
                                          null
                                      ? AppColors.GREEN.withOpacity(.2)
                                      : AppColors.RED.withOpacity(.2),
                                  child: MyText(
                                    fontSize: 14,
                                    textAlign: TextAlign.center,
                                    title:
                                        '${dateFormat2.format(nextSevenDays[i].listAppo[index].fromTime!)}\n${dateFormat2.format(nextSevenDays[i].listAppo[index].toTime!)}',
                                  ),
                                ),
                              );
                            },
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
  }
}
