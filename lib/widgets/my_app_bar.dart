import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservations_app/utils/app_colors.dart';
import 'package:reservations_app/widgets/my_text.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final String title;
  final double? leadingWidth;
  final Color textColor;

  const MyAppBar({
    Key? key,
    this.leading,
    this.actions,
    this.title = '',
    this.leadingWidth,
    this.textColor = AppColors.WHITE,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: leading,
      centerTitle: true,
      leadingWidth: leadingWidth != null ? leadingWidth!.w : null,
      title: MyText(
        title: title,
        fontSize: 18,
        color: textColor,
      ),
      actions: actions,
    );
  }

  Widget iconLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: SvgPicture.asset(
        'assets/images/ic_back.svg',
        width: 24.w,
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
