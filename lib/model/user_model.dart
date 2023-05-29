import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String id;
  late String number;
  late String username;
  late String email;
  late String password;
  late bool isLecturer;
  late String token;
  String? urlImage;

  UserModel({
    required this.id,
    required this.username,
    required this.number,
    required this.email,
    required this.password,
    required this.isLecturer,
    required this.token,
    required this.urlImage,
  });
  UserModel.updateUser({
    required this.id,
    required this.username,
    required this.urlImage,
  });

  UserModel.fromMap(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    username = jsonMap['username'];
    email = jsonMap['email'];
    password = jsonMap['password'];
    isLecturer = jsonMap['isLecturer'];
    token = jsonMap['token'];
    urlImage = jsonMap['urlImage'];
    number = jsonMap['number'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'isLecturer': isLecturer,
      'token': token,
      'urlImage': urlImage,
      'number': number,
    };
  }

  Map<String, dynamic> toMapUpdateUSER() {
    return {
      'id': id,
      'username': username,
      'urlImage': urlImage,
    };
  }

  UserModel.getUserFromDocument(QueryDocumentSnapshot snapshot) {
    id = snapshot.get('id');
    username = snapshot.get('username');
    email = snapshot.get('email');
    password = snapshot.get('password');
    isLecturer = snapshot.get('isLecturer');
    token = snapshot.get('token');
    urlImage = snapshot.get('urlImage');
    number = snapshot.get('number');
  }
}
