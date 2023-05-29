import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reservations_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/model/user_model.dart';
import 'package:reservations_app/pages/main/studet/bottom_nav/lecturer_screen.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:reservations_app/widgets/my_contianer_shape.dart';
import 'package:reservations_app/widgets/my_text.dart';

class Lecturers extends StatefulWidget {
  const Lecturers({super.key});

  @override
  State<Lecturers> createState() => _LecturersState();
}

class _LecturersState extends State<Lecturers> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    StudentAppointmentsCubit.get(context).getLecturer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentAppointmentsCubit, StudentAppointmentsState>(
      builder: (context, state) {
        if (state is LoadingLecturersData) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        List<UserModel> listData =
            StudentAppointmentsCubit.get(context).listLecturer;
        if (listData.length == 0) {
          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView(
              children: [
                Center(
                  child:
                      MyText(title: AppLocalizations.of(context)!.thereNoData),
                ),
              ],
            ),
          );
        }
        return SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: listData.length,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  AppHelpers.navigationToPage(
                    context,
                    LecturerScreen(lecturer: listData[index]),
                  );
                },
                child: MyContainerShape(
                  paddingHorizontal: 10,
                  paddingVertical: 10,
                  marginBottom: 15,
                  enableBorder: true,
                  child: Row(
                    children: [
                      Expanded(
                        child: MyText(
                          title: listData[index].username,
                        ),
                      ),
                      MyContainerShape(
                        borderRadius: 20,
                        height: 60.r,
                        width: 60.r,
                        enableBorder: true,
                        colorBorder: AppColors.BASE_COLOR,
                        child: listData[index].urlImage != null
                            ? Image.network(
                                listData[index].urlImage!,
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.person,
                                size: 30.r,
                                color: AppColors.GRAY,
                              ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onRefresh() async {
    await StudentAppointmentsCubit.get(context).getLecturer();
    _refreshController.refreshCompleted();
  }
}
