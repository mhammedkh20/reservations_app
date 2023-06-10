import 'package:reservations_app/model/user_model.dart';

class CustomClassDate {
  DateTime currentDateTime;
  String todayDate;
  String dayOfWeekAr;
  String dayOfWeekEn;
  List<Appointment> listAppo;

  CustomClassDate({
    required this.currentDateTime,
    required this.dayOfWeekAr,
    required this.dayOfWeekEn,
    required this.listAppo,
    required this.todayDate,
  });
}

class Appointment {
  String? id;
  String? idLecturer;
  String? idStudent;
  DateTime? fromTime;
  DateTime? toTime;
  DateTime? currentTime;
  UserModel? student;
  UserModel? lecturer;
  String? status;
  String? title;
  String? desc;
  String? expectedTime;

  Appointment({
    this.id,
    this.idLecturer,
    this.fromTime,
    this.toTime,
    this.currentTime,
    this.student,
    this.lecturer,
    this.status,
    this.title,
    this.desc,
    this.expectedTime,
    this.idStudent,
  });

  Appointment.fromMap(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    idLecturer = jsonMap['idLecturer'];
    idStudent = jsonMap['idStudent'];
    fromTime = DateTime.parse(jsonMap['fromTime']);
    toTime = DateTime.parse(jsonMap['toTime']);
    currentTime = DateTime.parse(jsonMap['currentTime']);
    status = jsonMap['status'];
    title = jsonMap['title'];
    desc = jsonMap['desc'];
    expectedTime = jsonMap['expectedTime'];
    student = jsonMap['student'] != null
        ? UserModel.fromMap(jsonMap['student'])
        : null;
    lecturer = jsonMap['lecturer'] != null
        ? UserModel.fromMap(jsonMap['lecturer'])
        : null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idLecturer': idLecturer,
      'idStudent': idStudent,
      'fromTime': fromTime.toString(),
      'toTime': toTime.toString(),
      'currentTime': currentTime.toString(),
      'status': status,
      'title': title,
      'desc': desc,
      'expectedTime': expectedTime,
      'student': student != null ? student!.toMap() : null,
      'lecturer': lecturer != null ? lecturer!.toMap() : null,
    };
  }
}
