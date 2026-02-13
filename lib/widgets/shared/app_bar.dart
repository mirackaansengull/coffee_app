import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final logoColor = isLight ? Colors.black : Colors.white;
    return AppBar(
      backgroundColor: colors.backgroundPrimary,
      toolbarHeight: 70.h,
      leadingWidth: 120.w,
      leading: Center(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
          child: Image.asset(
            'assets/images/logo_horizontal_light.png',
            width: 100.w,
            height: 40.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Container(
        height: 44.h,
        margin: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          gradient: colors.gradientSearchBar,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colors.surfaceBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: TextField(
          cursorColor: colors.cursor,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            hintText: 'Kahve Ara...',
            hintStyle: TextStyle(
              color: colors.textHint,
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w100,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(10.w),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
                child: Image.asset(
                  'assets/icons/search.png',
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.contain,
                ),
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
          style: TextStyle(color: colors.textPrimary, fontSize: 14.sp),
        ),
      ),
      titleSpacing: 0,
      actions: [SizedBox(width: 10.w)],
    );
  }
}
