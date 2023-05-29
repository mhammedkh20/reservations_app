import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservations_app/utils/app_colors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String textHint;
  final int? minLines;
  final int? maxLines;
  final bool obscureText;
  final bool isBorder;
  final String? Function(String?)? validator;
  final Color textColor;
  final Color hintColor;
  final ValueChanged<String>? onChange;
  final bool filledColor;
  final bool isDense;
  final Color fillColor;
  final Color? fillColor2;
  final double fontSize;
  final double paddingHorizontal;
  final double paddingVertical;
  final bool readOnly;
  final Widget? suffixWidget;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color colorBorder;
  final Function()? onTap;
  final Widget? prefixIcon;
  final bool isError;
  final bool isBorderUnderLine;
  final int? maxLength;

  const MyTextField({
    required this.textHint,
    this.obscureText = false,
    super.key,
    this.controller,
    this.maxLines,
    this.minLines,
    this.validator,
    this.isBorder = false,
    this.onTap,
    this.textColor = Colors.black,
    this.hintColor = AppColors.GRAY2,
    this.filledColor = false,
    this.fillColor = AppColors.TRANSPARENT,
    this.fillColor2 = AppColors.WHITE,
    this.onChange,
    this.isDense = false,
    this.fontSize = 14,
    this.paddingHorizontal = 10,
    this.paddingVertical = 0,
    this.autofocus = false,
    this.readOnly = false,
    this.suffixWidget,
    this.focusNode,
    this.colorBorder = AppColors.BORDER,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.isError = false,
    this.isBorderUnderLine = false,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      controller: controller,
      minLines: minLines,
      textInputAction: TextInputAction.done,
      maxLines: maxLines,
      validator: validator,
      readOnly: readOnly,
      maxLength: maxLength,
      onChanged: onChange,
      onTap: onTap,
      autofocus: autofocus,
      style: TextStyle(
        fontSize: fontSize.sp,
        color: textColor,
        fontFamily: 'Montserrat',
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal.w,
          vertical: paddingVertical.h,
        ),
        hintText: textHint,
        isDense: isDense,
        fillColor: fillColor2 ??
            (focusNode != null
                ? focusNode!.hasFocus
                    ? fillColor.withOpacity(.05)
                    : AppColors.TRANSPARENT
                : null),
        filled: filledColor,
        hintStyle: TextStyle(
          fontSize: fontSize.sp,
          color: hintColor,
          fontFamily: 'Montserrat',
        ),
        suffixIcon: suffixWidget,
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(),
        enabledBorder: isBorder
            ? isBorderUnderLine
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: isError ? AppColors.RED : colorBorder),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                        color: isError ? AppColors.RED : colorBorder),
                  )
            : InputBorder.none,
        focusedBorder: isBorder
            ? isBorderUnderLine
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: isError ? AppColors.RED : AppColors.BASE_COLOR))
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                        color: isError ? AppColors.RED : AppColors.BASE_COLOR))
            : InputBorder.none,
        focusedErrorBorder: isBorder
            ? isBorderUnderLine
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.BASE_COLOR),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.BASE_COLOR))
            : InputBorder.none,
        errorBorder: isBorder
            ? isBorderUnderLine
                ? const UnderlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.RED),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.RED),
                  )
            : InputBorder.none,
      ),
    );
  }
}
