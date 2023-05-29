import 'package:flutter/material.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyContainerShape extends StatelessWidget {
  Widget? child;
  Color shadow;
  Color? bgContainer;
  Color colorBorder;
  bool enableShadow;
  bool enableRadius;
  bool enableBorder;
  BoxShape boxShape;
  AlignmentDirectional? alignment;
  double? height;
  double? width;
  double widthBorder;
  double paddingVertical;
  double paddingHorizontal;
  double borderRadius;
  double xOffset;
  double yOffset;
  double blur;
  double marginTop;
  double marginBottom;
  double marginStart;
  double marginEnd;

  double topEndRaduis;
  double topStartRaduis;
  double bottomStartRaduis;
  double bottomEndRaduis;

  MyContainerShape({
    this.height,
    this.width,
    this.boxShape = BoxShape.rectangle,
    this.paddingVertical = 0,
    this.paddingHorizontal = 0,
    this.marginTop = 0,
    this.marginBottom = 0,
    this.marginStart = 0,
    this.marginEnd = 0,
    this.borderRadius = 30,
    this.xOffset = 0,
    this.widthBorder = 1,
    this.yOffset = 10,
    this.blur = 18,
    this.alignment = AlignmentDirectional.center,
    this.enableShadow = true,
    this.enableRadius = true,
    this.enableBorder = false,
    this.shadow = AppColors.BLACK0,
    this.bgContainer = AppColors.WHITE,
    this.colorBorder = AppColors.BORDER,
    this.child,
    this.bottomEndRaduis = 0,
    this.topStartRaduis = 0,
    this.topEndRaduis = 0,
    this.bottomStartRaduis = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      alignment: alignment,
      padding: EdgeInsets.symmetric(
        vertical: paddingVertical.h,
        horizontal: paddingHorizontal.w,
      ),
      margin: EdgeInsetsDirectional.only(
        top: marginTop,
        bottom: marginBottom,
        start: marginStart,
        end: marginEnd,
      ),
      decoration: BoxDecoration(
        color: bgContainer,
        shape: boxShape,
        borderRadius: enableRadius
            ? borderRadius != 0
                ? BorderRadius.circular(borderRadius)
                : BorderRadiusDirectional.only(
                    topEnd: Radius.circular(topEndRaduis.r),
                    topStart: Radius.circular(topStartRaduis.r),
                    bottomEnd: Radius.circular(bottomEndRaduis.r),
                    bottomStart: Radius.circular(bottomStartRaduis.r),
                  )
            : null,
        boxShadow: enableShadow
            ? [
                BoxShadow(
                  color: shadow.withOpacity(.05),
                  offset: Offset(xOffset, yOffset),
                  blurRadius: blur,
                ),
              ]
            : null,
        border: enableBorder
            ? Border.all(color: colorBorder, width: widthBorder)
            : null,
      ),
      child: child,
    );
  }
}
