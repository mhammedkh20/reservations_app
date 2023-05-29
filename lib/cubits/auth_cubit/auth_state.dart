part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoadingDataUser extends AuthState {}

class LoadingUpdateDataUser extends AuthState {}

class SuccessUpdateDataUser extends AuthState {}

class FailureUpdateDataUser extends AuthState {}
