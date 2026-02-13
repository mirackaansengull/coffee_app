import 'package:coffee_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundPrimary,
      toolbarHeight: 70.h,
      leadingWidth: 120.w,
      leading: Center(
        child: Image.asset(
          'assets/images/logo_horizontal_light.png',
          width: 100.w,
          height: 40.h,
          fit: BoxFit.contain,
        ),
      ),
      title: Container(
        height: 44.h,
        margin: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          gradient: AppGradients.searchBar,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: TextField(
          cursorColor: AppColors.cursor,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            hintText: 'Kahve Ara...',
            hintStyle: TextStyle(
              color: AppColors.textHint,
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w100,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(10.w),
              child: Image.asset(
                'assets/icons/search.png',
                width: 20.w,
                height: 20.w,
                fit: BoxFit.contain,
              ),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
        ),
      ),
      titleSpacing: 0,
      actions: [SizedBox(width: 10.w)],
    );
  }
}
