// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reservations_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:reservations_app/firestore/fb_firestore_controller.dart';
import 'package:reservations_app/model/custom_class_date.dart';
import 'package:reservations_app/model/notification_model.dart';
import 'package:reservations_app/model/user_model.dart';
import 'package:reservations_app/utils/app_constant.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:reservations_app/utils/notification_api.dart';

part 'student_appointments_state.dart';

enum StatusAppo { PENDING, IN_PROGRESS, DONE, CANCELED }

class StudentAppointmentsCubit extends Cubit<StudentAppointmentsState> {
  List<Appointment> listAppointment = [];
  List<Appointment> listReservations = [];

  StudentAppointmentsCubit() : super(StudentAppointmentsInitial());

  static StudentAppointmentsCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  Future getReservations({bool status = false}) async {
    Map<String, dynamic> availableTimes = AppHelpers.getFromAndEndDateTime();
    DateTime end = DateTime.parse(availableTimes['end_date'].toString());
    DateTime start = DateTime.parse(availableTimes['start_date'].toString());

    emit(LoadingReservationsData());
    QuerySnapshot<Map<String, dynamic>> data =
        await FbFirestoreController().getAppointmentsForStudent();

    listReservations.clear();
    if (status) {
      data.docs.map((e) {
        DateTime nnow = DateTime.parse(e.data()['currentTime'].toString());

        if (e.data()['student'] == null &&
            DateTime.now().isBetween(nnow, start, end)) {
          listReservations.add(Appointment.fromMap(e.data()));
        }
      }).toList();
    } else {
      data.docs.map((e) {
        DateTime nnow = DateTime.parse(e.data()['currentTime'].toString());

        if (e.data()['student'] != null &&
            DateTime.now().isBetween(nnow, start, end) &&
            e.data()['status'] == null) {
          listReservations.add(Appointment.fromMap(e.data()));
        }
      }).toList();
    }
    emit(StudentAppointmentsInitial());
  }

  int indexTapBar = 0;
  changeIndexTapBar(
    int index,
    BuildContext context, {
    bool withEmit = true,
    bool onRefresh = false,
  }) {
    if (index != indexTapBar || onRefresh) {
      indexTapBar = index;
      if (withEmit) {
        emit(StudentAppointmentsInitial());
      }
      String? status;
      switch (index) {
        case 0:
          status = StatusAppo.PENDING.toString();
          break;
        case 1:
          status = StatusAppo.IN_PROGRESS.toString();
          break;
        case 2:
          status = StatusAppo.DONE.toString();
          break;
      }
      print(status);
      getAppointments(status, context);
    }
  }

  changeIndexTapBarStudent(
    int index,
    BuildContext context, {
    bool withEmit = true,
    bool onRefresh = false,
  }) {
    if (index != indexTapBar || onRefresh) {
      indexTapBar = index;
      if (withEmit) {
        emit(StudentAppointmentsInitial());
      }
      String? status;
      switch (index) {
        case 0:
          status = StatusAppo.PENDING.toString();
          break;
        case 1:
          status = StatusAppo.IN_PROGRESS.toString();
          break;
        case 2:
          status = StatusAppo.DONE.toString();
          break;
      }
      getAppointmentsStudent(status, context);
    }
  }

  Future getAppointmentsStudent(String? status, BuildContext context) async {
    emit(LoadingAppointmentsData());
    QuerySnapshot<Map<String, dynamic>> data =
        await FbFirestoreController().getAppointmentsStudent(
      status,
      AuthCubit.get(context).user!.id,
    );

    listAppointment.clear();
    data.docs
        .map((e) => listAppointment.add(Appointment.fromMap(e.data())))
        .toList();

    emit(StudentAppointmentsInitial());
  }

  Future getAppointments(String? status, BuildContext context) async {
    emit(LoadingAppointmentsData());
    QuerySnapshot<Map<String, dynamic>> data = await FbFirestoreController()
        .getAppointments(status, AuthCubit.get(context).user!.id);

    listAppointment.clear();
    data.docs
        .map((e) => listAppointment.add(Appointment.fromMap(e.data())))
        .toList();

    emit(StudentAppointmentsInitial());
  }

  Future changeStatusReservations(
    BuildContext context,
    int index,
    String status,
  ) async {
    String id = listReservations[index].id!;
    bool changed = await FbFirestoreController().updateAppointment(
      id: id,
      data: {'status': status},
    );

    if (changed) {
      listReservations.removeAt(index);
      AppHelpers.showSnackBar(context,
          message:
              AppLocalizations.of(context)!.operationAccomplishedSuccessfully);
      emit(StudentAppointmentsInitial());
    }
  }

  Future cancelAppo(
    BuildContext context,
    int index,
  ) async {
    String id = listAppointment[index].id!;
    bool changed = await FbFirestoreController().updateAppointment(
      id: id,
      data: {
        'status': null,
        'idStudent': null,
        'student': null,
        'title': null,
        'desc': null,
        'expectedTime': null,
      },
    );

    if (changed) {
      listAppointment.removeAt(index);
      AppHelpers.showSnackBar(context,
          message:
              AppLocalizations.of(context)!.operationAccomplishedSuccessfully);
      emit(StudentAppointmentsInitial());
    }
  }

  Future changeStatusAppo(
    BuildContext context,
    int index,
    String status,
  ) async {
    String id = listAppointment[index].id!;
    bool changed;
    if (status == StatusAppo.DONE.toString()) {
      listAppointment[index].status = status;
      await FbFirestoreController().createAppointmentDone(
        appointment: listAppointment[index],
      );
      changed = await FbFirestoreController().updateAppointment(
        id: id,
        data: {
          'status': null,
          'idStudent': null,
          'student': null,
          'title': null,
          'desc': null,
          'expectedTime': null,
        },
      );
    } else if (status == StatusAppo.PENDING.toString()) {
      log('message');

      changed = await FbFirestoreController().updateAppointment(
        id: id,
        data: {'status': status},
      );
    } else {
      changed = await FbFirestoreController().updateAppointment(
        id: id,
        data: {'status': status},
      );
    }

    if (changed) {
      AppHelpers.showSnackBar(context,
          message:
              AppLocalizations.of(context)!.operationAccomplishedSuccessfully);
      emit(StudentAppointmentsInitial());
    }
  }

  Future sendRequestAppo(
    BuildContext context,
    int index,
    String title,
    String? desc,
    String expectTime,
  ) async {
    //!2
    String id = listReservations[index].id!;
    bool updated = await FbFirestoreController().updateAppointment(
      id: id,
      data: {
        'desc': desc == "" ? null : desc,
        'title': title,
        'status': StatusAppo.PENDING.toString(),
        'expectedTime': expectTime,
        'idStudent': AuthCubit.get(context).user!.id,
        'student': AuthCubit.get(context).user!.toMap(),
      },
    );

    if (updated) {
      listReservations.removeAt(index);
      AppHelpers.showSnackBar(context,
          message:
              AppLocalizations.of(context)!.operationAccomplishedSuccessfully);
      emit(StudentAppointmentsInitial());
    }
  }
  //!1

  Future sendRequestAppo2(
    BuildContext context,
    String id,
    String title,
    String? desc,
    String expectTime,
    int indexDay,
    int indexAppo,
  ) async {
    bool updated = await FbFirestoreController().updateAppointment(
      id: id,
      data: {
        'desc': desc == "" ? null : desc,
        'title': title,
        'status': StatusAppo.PENDING.toString(),
        'expectedTime': expectTime,
        'idStudent': AuthCubit.get(context).user!.id,
        'student': AuthCubit.get(context).user!.toMap(),
      },
    );

    if (updated) {
      allDate[indexDay].listAppo[indexAppo].student =
          AuthCubit.get(context).user!;
      AppHelpers.showSnackBar(context,
          message:
              AppLocalizations.of(context)!.operationAccomplishedSuccessfully);
      emit(StudentAppointmentsInitial());
    }
  }

  List<CustomClassDate> allDate = [];
  void getSevenDay(BuildContext context, {String? lecturerId}) {
    allDate.clear();
    getNextDaysDates(context, 7, lecturerId: lecturerId);
  }

  Future addPeriod(
    BuildContext context, {
    required DateTime fromPeriod,
    required DateTime endPeriod,
    required int index,
  }) async {
    bool statusStart = checkThePeriodIsExist(context, index, fromPeriod);
    bool statusEnd = checkThePeriodIsExist(context, index, endPeriod);
    if (statusStart && statusEnd) {
      Appointment appointment = Appointment(
        id: FbFirestoreController().generateId(),
        fromTime: fromPeriod,
        toTime: endPeriod,
        currentTime: allDate[index].currentDateTime,
        idLecturer: AuthCubit.get(context).user!.id,
        lecturer: AuthCubit.get(context).user,
        student: null,
      );

      FbFirestoreController().createAppointment(appointment: appointment);

      allDate[index].listAppo.add(appointment);
      saveNotification(
        context,
        NotificationModel(
          id: FbFirestoreController().generateId(),
          currentDateTime: DateTime.now().toString(),
          lecturerId: AuthCubit.get(context).user!.id,
          notificationId: AppConstantNotification.PUSH_APPOINTMENT,
          studentId: null,
          studentName: null,
          lecturerName: AuthCubit.get(context).user!.username,
        ),
      );
      NotificationApi.pushNotificationsAllUsers(
        body:
            '${AppLocalizations.of(context)!.theLecturerDid} “${AuthCubit.get(context).user!.username}” ${AppLocalizations.of(context)!.addingAvailableDatesReservation}',
        title: AppLocalizations.of(context)!.availabilityBookAppointment,
      );
    }
    emit(StudentAppointmentsInitial());
  }

  Future saveNotification(
      BuildContext context, NotificationModel notificationModel) async {
    await FbFirestoreController().createNotificaiton(notificationModel);
  }

  bool checkThePeriodIsExist(
    BuildContext context,
    int index,
    DateTime checkTime,
  ) {
    CustomClassDate day = allDate[index];
    for (int i = 0; i < day.listAppo.length; i++) {
      if (checkTime.isAfter(day.listAppo[i].fromTime!) &&
          checkTime.isBefore(day.listAppo[i].toTime!)) {
        String message =
            "${AppLocalizations.of(context)!.timePeriodContaining} ${checkTime.hour}:${checkTime.minute} ${AppLocalizations.of(context)!.isBetween} ${day.listAppo[i].fromTime!.hour}:${day.listAppo[i].fromTime!.minute} ${AppLocalizations.of(context)!.and} ${day.listAppo[i].toTime!.hour}:${day.listAppo[i].toTime!.minute}.";

        AppHelpers.showSnackBar(context, message: message, error: true);
        return false;
      }
    }
    return true;
  }

  deletePeriod({
    required int indexDay,
    required int indexPeriod,
  }) async {
    CustomClassDate day = allDate[indexDay];
    await FbFirestoreController()
        .deleteAppointments(day.listAppo[indexPeriod].id!);
    day.listAppo.removeAt(indexPeriod);
    emit(StudentAppointmentsInitial());
  }

  void getNextDaysDates(BuildContext context, int numOfDays,
      {String? lecturerId}) async {
    DateTime now = DateTime.now();

    DateFormat dateFormat3 = DateFormat.yMMMMd('en');
    DateFormat dateFormat = DateFormat.EEEE('ar');
    DateFormat dateFormat2 = DateFormat.Md('en');
    for (int i = 0; i < numOfDays; i++) {
      DateTime date = now.add(Duration(days: i));
      String s = dateFormat.format(date);
      if (s == 'الجمعة') {
        break;
      } else {
        allDate.add(
          CustomClassDate(
            currentDateTime: date,
            dayOfWeek: s,
            todayDate: dateFormat2.format(date),
            listAppo: [],
          ),
        );
      }
    }
    QuerySnapshot<Map<String, dynamic>> appointments =
        await FbFirestoreController().getAppointmentsForLecturer(
      lecturerId ?? AuthCubit.get(context).user!.id,
    );
    for (int i = 0; i < appointments.docs.length; i++) {
      Appointment appointment =
          Appointment.fromMap(appointments.docs[i].data());
      for (int j = 0; j < allDate.length; j++) {
        if (dateFormat3.format(appointment.currentTime!) ==
            dateFormat3.format(allDate[j].currentDateTime)) {
          allDate[j].listAppo.add(appointment);
        }
      }
    }
    emit(StudentAppointmentsInitial());
  }

  List<UserModel> listLecturer = [];

  Future getLecturer() async {
    emit(LoadingLecturersData());

    QuerySnapshot<Map<String, dynamic>> data =
        await FbFirestoreController().getLecturers();

    listLecturer.clear();
    data.docs
        .map((e) => listLecturer.add(UserModel.fromMap(e.data())))
        .toList();

    emit(StudentAppointmentsInitial());
  }
}

extension DateTimeExtension on DateTime? {
  bool isAfterOrEqualTo(DateTime date1, DateTime date2) {
    final isAtSameMomentAs = date1.isAtSameMomentAs(date2);

    return isAtSameMomentAs | date1.isAfter(date2);
  }

  bool isBeforeOrEqualTo(DateTime date1, DateTime date2) {
    final isAtSameMomentAs = date1.isAtSameMomentAs(date2);

    return isAtSameMomentAs | date1.isBefore(date2);
  }

  bool isBetween(
    DateTime currentDateTime,
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    currentDateTime = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day);
    fromDateTime =
        DateTime(fromDateTime.year, fromDateTime.month, fromDateTime.day);
    toDateTime = DateTime(toDateTime.year, toDateTime.month, toDateTime.day);

    final isAfter =
        currentDateTime.isAfterOrEqualTo(currentDateTime, fromDateTime);
    final isBefore =
        currentDateTime.isBeforeOrEqualTo(currentDateTime, toDateTime);
    return isAfter && isBefore;
  }
}
