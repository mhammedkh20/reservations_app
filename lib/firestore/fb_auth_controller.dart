import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reservations_app/utils/app_helpers.dart';

class FbAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _authMassaging = FirebaseMessaging.instance;
  final FirebaseFirestore _authFirestore = FirebaseFirestore.instance;

  Future<UserCredential?> createAccount(BuildContext context,
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Exception Message: ${e.message}');
      _controlExceptionCode(context, e.code);
    } catch (e) {}

    return null;
  }

  Future<bool> signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return await handleEmailValidation(context, userCredential);
    } on FirebaseAuthException catch (e) {
      _controlExceptionCode(context, e.code);
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> handleEmailValidation(
    BuildContext context,
    UserCredential userCredential,
  ) async {
    if (userCredential.user != null && !userCredential.user!.emailVerified) {
      await userCredential.user!.sendEmailVerification();
      AppHelpers.showSnackBar(context,
          message: AppLocalizations.of(context)!.messageCheckEmail,
          error: true);
      return false;
    }
    return true;
  }

  bool isLoggedIn() => _auth.currentUser != null;

  Future<void> signOut() async {
    _auth.signOut();
  }

  Future<bool> passwordReset(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      AppHelpers.showSnackBar(
        context,
        message: AppLocalizations.of(context)!.checkEmailToResetPassword,
        error: true,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _controlExceptionCode(context, e.code);
    } catch (e) {
      print(e);
    }
    return false;
  }

  void _controlExceptionCode(BuildContext context, String code) {
    if (code == 'email-already-in-use') {
      AppHelpers.showSnackBar(context,
          message: AppLocalizations.of(context)!.emailAlreadyInUse,
          error: true);
    } else if (code == 'invalid-email') {
      AppHelpers.showSnackBar(context,
          message: AppLocalizations.of(context)!.invalidEmail, error: true);
    } else if (code == 'operation-not-allowed') {
      AppHelpers.showSnackBar(context,
          message: AppLocalizations.of(context)!.operationNotAllowed,
          error: true);
    } else if (code == 'weak-password') {
      AppHelpers.showSnackBar(context,
          message: AppLocalizations.of(context)!.weakPassword, error: true);
    } else if (code == 'user-disabled') {
      AppHelpers.showSnackBar(context,
          message: AppLocalizations.of(context)!.userDisabled, error: true);
    } else if (code == 'wrong-password') {
      AppHelpers.showSnackBar(context,
          message: AppLocalizations.of(context)!.wrongPassword, error: true);
    } else if (code == 'user-not-found') {
      AppHelpers.showSnackBar(context,
          message: AppLocalizations.of(context)!.userNotFound, error: true);
    } else if (code == 'invalid-action-code') {
      AppHelpers.showSnackBar(context,
          message: AppLocalizations.of(context)!.userNotFound, error: true);
    }
  }

  Future<String?> getToken() async {
    return await _authMassaging.getToken();
  }

  String getUserUrlImage() {
    print(_auth.currentUser!.displayName);
    return _auth.currentUser!.uid;
  }
}
