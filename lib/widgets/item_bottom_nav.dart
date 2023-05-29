import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/widgets/my_contianer_shape.dart';
import 'package:reservations_app/widgets/my_text.dart';

class ItemBottomNav extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function()? onTap;
  const ItemBottomNav({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: SizedBox(
              height: 60.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  MyText(
                    textAlign: TextAlign.center,
                    title: title,
                    fontSize: 12,
                    color: isSelected ? AppColors.BASE_COLOR : AppColors.GRAY,
                  ),
                  AnimatedSize(
                    duration: Duration(
                      milliseconds: 200,
                    ),
                    child: SizedBox(
                      child: isSelected
                          ? MyContainerShape(
                              height: 3,
                              width: 30.w,
                              borderRadius: 4,
                              bgContainer: AppColors.BASE_COLOR,
                            )
                          : SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
