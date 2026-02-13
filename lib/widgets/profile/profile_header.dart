import 'package:coffee_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    this.userName = 'Kullanıcı Adı',
    this.userEmail = 'kullanici@email.com',
    this.onNotificationTap,
  });

  final String userName;
  final String userEmail;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: onNotificationTap ?? () {},
              icon: Icon(
                Icons.notifications_outlined,
                size: 24.sp,
                color: AppColors.textPrimary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ],
        ),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 36.r,
                backgroundColor: AppColors.surfaceDark,
                child: Icon(
                  Icons.person_rounded,
                  size: 38.sp,
                  color: AppColors.textHint,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
