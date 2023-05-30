import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:reservations_app/cubits/student_appointments_cubit/student_appointments_cubit.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/utils/app_helpers.dart';
import 'package:reservations_app/widgets/my_elevated_button.dart';
import 'package:reservations_app/widgets/my_text.dart';
import 'package:reservations_app/widgets/my_text_field.dart';

class AppDialogs {
  static addAppointmentDialog(BuildContext context, {required int index}) {
    DateFormat dateFormat2 = DateFormat.Hm('en');
    DateTime? _fromDateTime;
    DateTime? _toDateTime;
    TextEditingController _fromController = TextEditingController();
    TextEditingController _toController = TextEditingController();
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      backgroundColor: AppColors.WHITE,
      contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      titlePadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 52.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(title: AppLocalizations.of(context)!.addAppointment),
            SizedBox(height: 10.h),
            MyText(
              fontSize: 14,
              color: AppColors.GRAY,
              title: AppLocalizations.of(context)!.choosePeriods,
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                MyText(
                  title: AppLocalizations.of(context)!.fromTheHour,
                  fontSize: 14,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: MyTextField(
                    controller: _fromController,
                    filledColor: true,
                    onTap: () {
                      Navigator.of(context).push(
                        showPicker(
                          context: context,
                          value: Time(hour: 8, minute: 0),
                          onChange: (Time time) {},
                          maxHour: 15,
                          minHour: 8,
                          disableAutoFocusToNextInput: true,
                          minuteInterval: TimePickerInterval.ONE,
                          onChangeDateTime: (DateTime dateTime) {
                            _fromDateTime = dateTime;
                            _fromController.text = dateFormat2.format(dateTime);
                          },
                          is24HrFormat: true,
                        ),
                      );
                    },
                    isBorder: true,
                    readOnly: true,
                    fontSize: 12,
                    fillColor2: AppColors.WHITE2,
                    textHint: '',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(width: 10.w),
                MyText(
                  title: AppLocalizations.of(context)!.toTheHour,
                  fontSize: 14,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: MyTextField(
                    controller: _toController,
                    filledColor: true,
                    onTap: () {
                      Navigator.of(context).push(
                        showPicker(
                          context: context,
                          value: Time(hour: 8, minute: 0),
                          onChange: (Time time) {},
                          maxHour: 15,
                          disableAutoFocusToNextInput: true,
                          minHour: 8,
                          minuteInterval: TimePickerInterval.ONE,
                          onChangeDateTime: (DateTime dateTime) {
                            _toDateTime = dateTime;

                            _toController.text = dateFormat2.format(dateTime);
                          },
                          is24HrFormat: true,
                        ),
                      );
                    },
                    isBorder: true,
                    readOnly: true,
                    fontSize: 12,
                    fillColor2: AppColors.WHITE2,
                    textHint: '',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: MyElevatedButton(
                    title: AppLocalizations.of(context)!.cancel,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    background: AppColors.WHITE,
                    borderColor: AppColors.RED,
                    titleColor: AppColors.RED,
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: MyElevatedButton(
                    title: AppLocalizations.of(context)!.addition,
                    onPressed: () async {
                      if (_fromController.text.isNotEmpty &&
                          _toController.text.isNotEmpty) {
                        if (_fromDateTime!.hour == _toDateTime!.hour &&
                            _fromDateTime!.minute == _toDateTime!.minute) {
                          AppHelpers.showSnackBar(
                            context,
                            message:
                                AppLocalizations.of(context)!.timesCorrectly,
                            error: true,
                          );
                        } else if (_fromDateTime!.hour < _toDateTime!.hour ||
                            (_fromDateTime!.hour == _toDateTime!.hour &&
                                _fromDateTime!.minute < _toDateTime!.minute)) {
                          await StudentAppointmentsCubit.get(context).addPeriod(
                            context,
                            fromPeriod: _fromDateTime!,
                            endPeriod: _toDateTime!,
                            index: index,
                          );
                          Navigator.of(context).pop();
                        } else {
                          AppHelpers.showSnackBar(
                            context,
                            message:
                                AppLocalizations.of(context)!.timesCorrectly,
                            error: true,
                          );
                        }
                      } else {
                        AppHelpers.showSnackBar(
                          context,
                          message: AppLocalizations.of(context)!.mustFilledOut,
                          error: true,
                        );
                      }
                    },
                    background: AppColors.GREEN,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static reservationRequestDialog(
    BuildContext context, {
    required DateTime fromTime,
    required DateTime toTime,
    required int indexDay,
    required int indexAppo,
    required String idAppo,
  }) {
    final _key = GlobalKey<FormState>();

    TextEditingController _titleController = TextEditingController();
    TextEditingController _descController = TextEditingController();
    TextEditingController _expectedTimeController = TextEditingController();

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      backgroundColor: AppColors.WHITE,
      contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      titlePadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 52.w,
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(title: AppLocalizations.of(context)!.reservationRequest),
              SizedBox(height: 10.h),
              MyText(
                fontSize: 14,
                color: AppColors.GRAY,
                title:
                    'ستقوم بحجز الفترة ما بين ${fromTime.hour}:${fromTime.minute} و ${toTime.hour}:${toTime.minute}',
              ),
              SizedBox(height: 35.h),
              MyTextField(
                controller: _titleController,
                textHint: AppLocalizations.of(context)!.topicTitle,
                isBorder: true,
                fontSize: 12,
                validator: (String? s) {
                  if (s == null || s.isEmpty) {
                    return AppLocalizations.of(context)!
                        .pleaseFillInTheFieldAbove;
                  }

                  return null;
                },
              ),
              SizedBox(height: 10.h),
              MyTextField(
                controller: _descController,
                textHint: AppLocalizations.of(context)!.topicDescription,
                isBorder: true,
                fontSize: 12,
              ),
              SizedBox(height: 10.h),
              MyTextField(
                controller: _expectedTimeController,
                textHint: AppLocalizations.of(context)!.durationInMinutes,
                isBorder: true,
                fontSize: 12,
                validator: (String? s) {
                  if (s == null || s.isEmpty) {
                    return AppLocalizations.of(context)!
                        .pleaseFillInTheFieldAbove;
                  }

                  return null;
                },
              ),
              SizedBox(height: 35.h),
              Row(
                children: [
                  Expanded(
                    child: MyElevatedButton(
                      title: AppLocalizations.of(context)!.cancel,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      background: AppColors.WHITE,
                      borderColor: AppColors.RED,
                      titleColor: AppColors.RED,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: MyElevatedButton(
                      title: AppLocalizations.of(context)!.addAppointment,
                      onPressed: () async {
                        //!1

                        StudentAppointmentsCubit.get(context).sendRequestAppo2(
                          context,
                          idAppo,
                          _titleController.text.trim(),
                          _descController.text.trim(),
                          _expectedTimeController.text.trim(),
                          indexDay,
                          indexAppo,
                        );
                        Navigator.of(context).pop();
                      },
                      background: AppColors.GREEN,
                      borderColor: AppColors.GREEN,
                      titleColor: AppColors.WHITE,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
