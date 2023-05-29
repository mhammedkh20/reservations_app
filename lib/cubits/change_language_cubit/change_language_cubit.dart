import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'change_language_state.dart';

class ChangeLanguageCubit extends Cubit<ChangeLanguageState> {
  ChangeLanguageCubit() : super(ChangeLanguageInitial());

  static ChangeLanguageCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  String strLanguage = 'ar';
  changeLanguage(String lang) {
    strLanguage = lang;
    emit(ChangeLanguageInitial());
  }
}
