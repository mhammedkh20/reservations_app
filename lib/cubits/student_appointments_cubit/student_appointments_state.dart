part of 'student_appointments_cubit.dart';

@immutable
abstract class StudentAppointmentsState {}

class StudentAppointmentsInitial extends StudentAppointmentsState {}

class LoadingAppointmentsData extends StudentAppointmentsState {}

class LoadingReservationsData extends StudentAppointmentsState {}

class LoadingLecturersData extends StudentAppointmentsState {}
