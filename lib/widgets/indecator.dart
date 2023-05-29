import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservations_app/utils/app_colors.dart';

class Indecatior extends StatelessWidget {
  final bool selected;
  const Indecatior({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: selected ? 20.w : 10.w,
      height: 5.h,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.BASE_COLOR
            : AppColors.BASE_COLOR.withOpacity(.2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
