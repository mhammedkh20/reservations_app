import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/firestore/fb_auth_controller.dart';
import 'package:reservations_app/firestore/fb_firestore_controller.dart';
import 'package:reservations_app/firestore/fb_storage_controller.dart';
import 'package:reservations_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  FbFirestoreController _instanceFirestore = FbFirestoreController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  static AuthCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  int? sh;

  String? pathImage;
  bool picked = false;
  Future pickImageUser() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pathImage = image.path;
      picked = true;

      emit(AuthInitial());
    }
  }

  UserModel? user;

  getDataUser() async {
    emit(LoadingDataUser());
    QuerySnapshot querySnapshot = await _instanceFirestore
        .getUserFromFirestore(_auth.currentUser!.email!);

    user = UserModel.getUserFromDocument(querySnapshot.docs[0]);

    emit(AuthInitial());
  }

  getDataUserLecturer(BuildContext context) async {
    emit(LoadingDataUser());
    QuerySnapshot querySnapshot = await _instanceFirestore
        .getUserFromFirestore(_auth.currentUser!.email!);

    user = UserModel.getUserFromDocument(querySnapshot.docs[0]);
    StudentAppointmentsCubit.get(context)
        .changeIndexTapBar(0, context, onRefresh: true);
    emit(AuthInitial());
  }

  Future updateUser(BuildContext context, {required String username}) async {
    emit(LoadingUpdateDataUser());
    String image;
    if (pathImage != null) {
      image = await FbStorageController().uploadImage(XFile(pathImage!));
    } else {
      image = user!.urlImage!;
    }
    bool updated = await _instanceFirestore.updateUser(
      user: UserModel.updateUser(
        id: user!.id,
        username: username,
        urlImage: image,
      ),
    );
    if (updated) {
      user!.username = username;
      user!.urlImage = image;
      emit(SuccessUpdateDataUser());
    } else {
      emit(FailureUpdateDataUser());
    }
  }
}
