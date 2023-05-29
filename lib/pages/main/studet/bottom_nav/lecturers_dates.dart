import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/model/custom_class_date.dart';
import 'package:reservations_app/widgets/item_reservations.dart';
import 'package:reservations_app/widgets/item_reservations_student.dart';
import 'package:reservations_app/widgets/my_text.dart';

class LecturersDates extends StatefulWidget {
  const LecturersDates({super.key});

  @override
  State<LecturersDates> createState() => _LecturersDatesState();
}

class _LecturersDatesState extends State<LecturersDates> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    StudentAppointmentsCubit.get(context).getReservations(status: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentAppointmentsCubit, StudentAppointmentsState>(
      builder: (context, state) {
        if (state is LoadingAppointmentsData) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        List<Appointment> listData =
            StudentAppointmentsCubit.get(context).listReservations;
        if (listData.length == 0) {
          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: Center(
              child: MyText(title: AppLocalizations.of(context)!.thereNoData),
            ),
          );
        }
        return SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: listData.length,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            itemBuilder: (context, index) {
              return ItemReservationStudent(
                appointment: listData[index],
                index: index,
              );
            },
          ),
        );
      },
    );
  }

  void _onRefresh() async {
    await StudentAppointmentsCubit.get(context).getReservations(status: true);
    _refreshController.refreshCompleted();
  }
}
