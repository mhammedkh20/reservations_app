// ignore_for_file: use_build_context_synchronously

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservations_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/firestore/fb_auth_controller.dart';
import 'package:reservations_app/firestore/fb_firestore_controller.dart';
import 'package:reservations_app/model/custom_class_date.dart';
import 'package:reservations_app/model/notification_model.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_constant.dart';
import 'package:reservations_app/utils/notification_api.dart';
import 'package:reservations_app/widgets/my_contianer_shape.dart';
import 'package:reservations_app/widgets/my_elevated_button.dart';
import 'package:reservations_app/widgets/my_text.dart';
import 'package:reservations_app/widgets/my_text_field.dart';

class ItemStudentAppointments extends StatelessWidget {
  const ItemStudentAppointments({
    super.key,
    required this.appointment,
    required this.index,
  });

  final int index;
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descController = TextEditingController();
    TextEditingController _expectedTimeController = TextEditingController();
    DateFormat dateFormat = DateFormat.EEEE('ar');
    DateFormat dateFormat2 = DateFormat.Hm('en');

    _titleController.text = appointment.title ?? "";
    _descController.text = appointment.desc ?? "";
    _expectedTimeController.text = appointment.expectedTime ?? "";

    return MyContainerShape(
      marginBottom: 20.h,
      borderRadius: 20,
      enableShadow: true,
      paddingHorizontal: 20,
      paddingVertical: 15,
      enableBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      title: appointment.student!.username,
                      fontSize: 14,
                    ),
                    SizedBox(height: 10.h),
                    MyText(
                      title: appointment.student!.number,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
              MyContainerShape(
                borderRadius: 5,
                height: 50.r,
                width: 50.r,
                enableBorder: true,
                colorBorder: AppColors.BASE_COLOR,
                child: appointment.student!.urlImage != null
                    ? Image.network(
                        appointment.student!.urlImage!,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.person,
                        size: 30.r,
                        color: AppColors.GRAY,
                      ),
              )
            ],
          ),
          SizedBox(height: 10.h),
          MyText(
            title: '${AppLocalizations.of(context)!.title} : ',
            color: AppColors.GRAY,
            fontSize: 14,
          ),
          SizedBox(height: 10.h),
          MyTextField(
            controller: _titleController,
            textHint: AppLocalizations.of(context)!.topicTitle,
            isBorder: true,
            readOnly: true,
            fontSize: 12,
          ),
          SizedBox(height: 10.h),
          if (appointment.desc != null) ...[
            MyTextField(
              controller: _descController,
              textHint: AppLocalizations.of(context)!.topicDescription,
              isBorder: true,
              readOnly: true,
              fontSize: 12,
            ),
            SizedBox(height: 10.h),
          ],
          MyText(
            title: '${AppLocalizations.of(context)!.theAppointment} : ',
            color: AppColors.GRAY,
            fontSize: 14,
          ),
          SizedBox(height: 10.h),
          MyText(
            title:
                '${AppLocalizations.of(context)!.day} ${dateFormat.format(appointment.currentTime!)} ${AppLocalizations.of(context)!.fromTheHour} ${dateFormat2.format(appointment.fromTime!)} ${AppLocalizations.of(context)!.to} ${dateFormat2.format(appointment.toTime!)}',
            fontSize: 14,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              MyText(
                color: AppColors.GRAY,
                title: '${AppLocalizations.of(context)!.expectedDuration} : ',
                fontSize: 14,
              ),
              Expanded(
                child: MyTextField(
                  controller: _expectedTimeController,
                  textHint: AppLocalizations.of(context)!.durationInMinutes,
                  isBorder: true,
                  fontSize: 12,
                  readOnly: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (StudentAppointmentsCubit.get(context).indexTapBar == 0) ...[
            Row(
              children: [
                Expanded(
                  child: MyElevatedButton(
                    title: AppLocalizations.of(context)!.accept,
                    background: AppColors.GREEN,
                    onPressed: () async {
                      await StudentAppointmentsCubit.get(context)
                          .changeStatusAppo(
                        context,
                        index,
                        StatusAppo.IN_PROGRESS.toString(),
                      );

                      await StudentAppointmentsCubit.get(context)
                          .saveNotification(
                        context,
                        NotificationModel(
                          notificationId:
                              AppConstantNotification.ACCEPT_APPOINTMENT,
                          id: FbFirestoreController().generateId(),
                          lecturerId: AuthCubit.get(context).user!.id,
                          lecturerName: AuthCubit.get(context).user!.username,
                          studentId: appointment.student!.id,
                          currentDateTime: DateTime.now().toString(),
                          studentName: appointment.student!.username,
                        ),
                      );
                      await NotificationApi.pushNotificationsToUser(
                        body:
                            '${AppLocalizations.of(context)!.theLecturerDid} “${AuthCubit.get(context).user!.username}” ${AppLocalizations.of(context)!.acceptingStudentReservation} “${appointment.student!.username}”',
                        title: AppLocalizations.of(context)!
                            .acceptanceOfBookingSessionWithTheLecturer,
                        fcm: appointment.student!.token,
                      );

                      StudentAppointmentsCubit.get(context)
                          .changeIndexTapBar(1, context, withEmit: false);
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: MyElevatedButton(
                    title: AppLocalizations.of(context)!.cancelReservations,
                    onPressed: () async {
                      await StudentAppointmentsCubit.get(context).cancelAppo(
                        context,
                        index,
                      );
                    },
                    background: AppColors.RED,
                  ),
                ),
              ],
            ),
          ],
          if (StudentAppointmentsCubit.get(context).indexTapBar == 1) ...[
            MyElevatedButton(
              title: AppLocalizations.of(context)!.ending,
              onPressed: () async {
                await StudentAppointmentsCubit.get(context).changeStatusAppo(
                    context, index, StatusAppo.DONE.toString());
                await StudentAppointmentsCubit.get(context).saveNotification(
                  context,
                  NotificationModel(
                    notificationId: AppConstantNotification.FINISH_APPOINTMENT,
                    id: FbFirestoreController().generateId(),
                    lecturerId: AuthCubit.get(context).user!.id,
                    lecturerName: AuthCubit.get(context).user!.username,
                    studentId: appointment.student!.id,
                    currentDateTime: DateTime.now().toString(),
                    studentName: appointment.student!.username,
                  ),
                );
                await NotificationApi.pushNotificationsToUser(
                  body:
                      '${AppLocalizations.of(context)!.theLecturerDid} “${AuthCubit.get(context).user!.username}” ${AppLocalizations.of(context)!.endTheSessionWithTheStudent} “${appointment.student!.username}”',
                  title: AppLocalizations.of(context)!
                      .endTheSessionWithTheLecturer,
                  fcm: appointment.student!.token,
                );
                StudentAppointmentsCubit.get(context)
                    .changeIndexTapBar(2, context, withEmit: false);
              },
            ),
          ],
        ],
      ),
    );
  }
}
