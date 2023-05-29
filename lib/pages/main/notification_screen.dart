import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservations_app/firestore/fb_firestore_controller.dart';
import 'package:reservations_app/model/notification_model.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_constant.dart';
import 'package:reservations_app/widgets/my_app_bar.dart';
import 'package:reservations_app/widgets/my_contianer_shape.dart';
import 'package:reservations_app/widgets/my_text.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.notifications,
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: FbFirestoreController().getNotificaitons(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          List<NotificationModel> listNotification = snapshot.data ?? [];
          return ListView.builder(
            itemCount: listNotification.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            itemBuilder: (context, index) {
              return MyContainerShape(
                paddingVertical: 15,
                paddingHorizontal: 15,
                marginBottom: 12,
                borderRadius: 10,
                enableShadow: true,
                enableBorder: true,
                child: Column(
                  children: [
                    listNotification[index].notificationId ==
                            AppConstantNotification.PUSH_APPOINTMENT
                        ? MyText(
                            title:
                                '${AppLocalizations.of(context)!.theLecturerDid} ${listNotification[index].lecturerName!} ${AppLocalizations.of(context)!.addingAvailableDatesReservation}')
                        : listNotification[index].notificationId ==
                                AppConstantNotification.FINISH_APPOINTMENT
                            ? MyText(
                                title:
                                    '${AppLocalizations.of(context)!.theLecturerDid} ${listNotification[index].lecturerName!} ${AppLocalizations.of(context)!.endTheSessionWithTheStudent} ${listNotification[index].studentName!}')
                            : MyText(
                                title:
                                    '${AppLocalizations.of(context)!.theLecturerDid} ${listNotification[index].lecturerName!} ${AppLocalizations.of(context)!.acceptingStudentReservation} ${listNotification[index].studentName!}'),
                    const SizedBox(height: 10),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: MyText(
                        title: DateFormat.yMd('ar')
                            .format(DateTime.parse(listNotification[index]
                                .currentDateTime
                                .toString()))
                            .toString(),
                        fontSize: 13,
                        color: AppColors.GRAY,
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
