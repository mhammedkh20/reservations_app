import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservations_app/model/bottom_nav_model.dart';
import 'package:reservations_app/pages/main/lecturer/bottom_nav/add_appointments.dart';
import 'package:reservations_app/pages/main/lecturer/bottom_nav/lecturer_profile_personly.dart';
import 'package:reservations_app/pages/main/lecturer/bottom_nav/student_appointments.dart';
import 'package:reservations_app/pages/main/studet/bottom_nav/lecturers.dart';
import 'package:reservations_app/pages/main/studet/bottom_nav/lecturers_dates.dart';
import 'package:reservations_app/pages/main/studet/bottom_nav/my_bookings.dart';
import 'package:reservations_app/pages/main/studet/bottom_nav/student_profile_personly.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  List<BottomNavModel> itemsLecturer(BuildContext context) {
    return [
      // BottomNavModel(
      //   title: AppLocalizations.of(context)!.reservations,
      //   widget: Reservations(),
      // ),
      BottomNavModel(
        title: AppLocalizations.of(context)!.studentAppointments,
        widget: StudentAppointments(),
      ),
      BottomNavModel(
        title: AppLocalizations.of(context)!.addAppointments,
        widget: AddAppointments(),
      ),
      BottomNavModel(
        title: AppLocalizations.of(context)!.profilePersonly,
        widget: LecturerProfilePersonly(),
      ),
    ];
  }

  List<BottomNavModel> itemsStudet(BuildContext context) {
    return [
      BottomNavModel(
        title: AppLocalizations.of(context)!.lecturersDates,
        widget: LecturersDates(),
      ),
      BottomNavModel(
        title: AppLocalizations.of(context)!.lecturers,
        widget: Lecturers(),
      ),
      BottomNavModel(
        title: AppLocalizations.of(context)!.myBookings,
        widget: MyBookings(),
      ),
      BottomNavModel(
        title: AppLocalizations.of(context)!.profilePersonly,
        widget: StudentProfilePersonly(),
      ),
    ];
  }

  int page = 0;
  changeIndexPage(int index) {
    page = index;
    emit(MainInitial());
  }
}
