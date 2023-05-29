class NotificationModel {
  String? id;
  int? notificationId;
  String? lecturerId;
  String? studentId;
  String? lecturerName;
  String? studentName;
  String? currentDateTime;

  NotificationModel({
    this.id,
    this.currentDateTime,
    this.lecturerId,
    this.lecturerName,
    this.notificationId,
    this.studentId,
    this.studentName,
  });

  NotificationModel.fromMap(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    notificationId = jsonMap['notificationId'];
    currentDateTime = jsonMap['currentDateTime'];
    lecturerId = jsonMap['lecturerId'];
    lecturerName = jsonMap['lecturerName'];
    studentId = jsonMap['studentId'];
    studentName = jsonMap['studentName'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notificationId': notificationId,
      'currentDateTime': currentDateTime,
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'studentId': studentId,
      'studentName': studentName,
    };
  }
}
