import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/model/custom_class_date.dart';
import 'package:reservations_app/widgets/item_reservations_student.dart';
import 'package:reservations_app/widgets/item_student_appo.dart';
import 'package:reservations_app/widgets/my_tapbar.dart';
import 'package:reservations_app/widgets/my_tapbar_student.dart';
import 'package:reservations_app/widgets/my_text.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          MyTapBarStudent(),
          SizedBox(height: 20.h),
          Expanded(
            child:
                BlocBuilder<StudentAppointmentsCubit, StudentAppointmentsState>(
              builder: (context, state) {
                if (state is LoadingAppointmentsData) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                List<Appointment> listData =
                    StudentAppointmentsCubit.get(context).listAppointment;
                if (listData.length == 0) {
                  return SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: ListView(
                      children: [
                        Center(
                          child: MyText(
                              title: AppLocalizations.of(context)!.thereNoData),
                        ),
                      ],
                    ),
                  );
                }

                return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: listData.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return ItemReservationStudent(
                        isReservationRequest: false,
                        isReadOnly: true,
                        index: index,
                        appointment: listData[index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onRefresh() async {
    int indexTaped = StudentAppointmentsCubit.get(context).indexTapBar;
    await StudentAppointmentsCubit.get(context)
        .changeIndexTapBarStudent(indexTaped, context, onRefresh: true);
    _refreshController.refreshCompleted();
  }
}
