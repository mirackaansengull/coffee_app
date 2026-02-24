import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'Hakkında',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        backgroundColor: colors.backgroundPrimary,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Icon(Icons.coffee_rounded, size: 80.sp, color: colors.textHint),
            SizedBox(height: 16.h),
            Text(
              'Kahve App',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Siparişlerinizi kolayca verin, favori kahvelerinizi keşfedin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.5,
                color: colors.textHint,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colors.surfaceDark,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: colors.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Versiyon',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textHint,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '1.0.0',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
