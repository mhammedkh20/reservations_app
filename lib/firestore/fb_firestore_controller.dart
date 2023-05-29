import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservations_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/model/custom_class_date.dart';
import 'package:reservations_app/model/notification_model.dart';
import 'package:reservations_app/model/user_model.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FbFirestoreController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getOneUser(String id) async {
    return _fireStore.collection('users').where('id', isEqualTo: id).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers() async {
    return _fireStore.collection('users').get();
  }

  Future<bool> createUser({required UserModel user}) async {
    return await _fireStore
        .doc('users/${user.id}')
        .set(user.toMap())
        .then((value) => true)
        .catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> updateUser({required UserModel user}) async {
    return await _fireStore
        .doc('users/${user.id}')
        .update(user.toMapUpdateUSER())
        .then((value) => true)
        .catchError((error) {
      print(error);
      return false;
    });
  }

  Future<QuerySnapshot> getUserFromFirestore(String email) async {
    return await _fireStore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  Future<bool> createAppointment({required Appointment appointment}) async {
    return await _fireStore
        .doc('appointments/${appointment.id}')
        .set(appointment.toMap())
        .then((value) => true)
        .catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> createAppointmentDone({required Appointment appointment}) async {
    return await _fireStore
        .doc('appointments-done/${appointment.id}')
        .set(appointment.toMap())
        .then((value) => true)
        .catchError((error) {
      print(error);
      return false;
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAppointmentsForLecturer(
      String id) async {
    return await _fireStore
        .collection('appointments')
        .where('idLecturer', isEqualTo: id)
        .get();
  }

  Future<bool> deleteAppointments(String appointmentId) async {
    return _fireStore
        .collection('appointments')
        .doc(appointmentId)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAppointments(
      String? status, String id) async {
    if (status == StatusAppo.DONE.toString()) {
      return _fireStore
          .collection('appointments-done')
          .where('status', isEqualTo: status)
          .where('idLecturer', isEqualTo: id)
          .get();
    } else {
      return _fireStore
          .collection('appointments')
          .where('status', isEqualTo: status)
          .where('idLecturer', isEqualTo: id)
          .get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAppointmentsStudent(
      String? status, String id) async {
    if (status == StatusAppo.DONE.toString()) {
      return _fireStore
          .collection('appointments-done')
          .where('status', isEqualTo: status)
          .where('idStudent', isEqualTo: id)
          .get();
    } else if (status == StatusAppo.PENDING.toString()) {
      return _fireStore
          .collection('appointments')
          // .where('student', isNull: false)
          .where('status', isEqualTo: status)
          .where('idStudent', isEqualTo: id)
          .get();
    } else {
      return _fireStore
          .collection('appointments')
          .where('status', isEqualTo: status)
          .where('idStudent', isEqualTo: id)
          .get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>>
      getAppointmentsForStudent() async {
    return _fireStore.collection('appointments').get();
  }

  Future<bool> updateAppointment(
      {required String id, required Map<String, dynamic> data}) async {
    return await _fireStore
        .doc('appointments/${id}')
        .update(data)
        .then((value) => true)
        .catchError((error) {
      print(error);
      return false;
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLecturers() async {
    return _fireStore
        .collection('users')
        .where('isLecturer', isEqualTo: true)
        .get();
  }

  Future<bool> createNotificaiton(NotificationModel notification) async {
    return await _fireStore
        .doc('notifications/${notification.id}')
        .set(notification.toMap())
        .then((value) => true)
        .catchError((error) {
      print(error);
      return false;
    });
  }

  Future<List<NotificationModel>> getNotificaitons(BuildContext context) async {
    bool isLecturer = AuthCubit.get(context).user!.isLecturer;
    QuerySnapshot<Map<String, dynamic>> query;
    if (isLecturer) {
      query = await _fireStore
          .collection('notifications')
          .where('lecturerId', isEqualTo: AuthCubit.get(context).user!.id)
          .get();
    } else {
      query = await _fireStore
          .collection('notifications')
          .where('notificationId', isEqualTo: 1)
          .get();
    }
    List<NotificationModel> listNotification = [];

    if (isLecturer) {
      query.docs.map((e) {
        listNotification.add(NotificationModel.fromMap(e.data()));
      }).toList();
    } else {
      query.docs.map((e) {
        if (e.data()['studentId'] == null ||
            e.data()['studentId'] == AuthCubit.get(context).user!.id)
          listNotification.add(NotificationModel.fromMap(e.data()));
      }).toList();
    }
    return listNotification;
  }

  String generateId() {
    return _fireStore.collection('generateId').doc().id;
  }
}
