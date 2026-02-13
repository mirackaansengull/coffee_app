import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    this.userName = 'Kullanıcı Adı',
    this.userEmail = 'kullanici@email.com',
    this.onNotificationTap,
    required this.onThemeToggle,
  });

  final String userName;
  final String userEmail;
  final VoidCallback? onNotificationTap;
  final VoidCallback onThemeToggle;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(height: 8.h),
        Row(
          children: [
            // Sol üst: kaydırmalı tema geçiş (basınca geçilen temanın ikonuna kayar)
            _ThemeToggleSwitch(
              isDark: isDark,
              onToggle: onThemeToggle,
              iconColor: colors.textPrimary,
              trackColor: colors.surfaceDark,
              thumbColor: colors.surfaceMedium,
            ),
            const Spacer(),
            IconButton(
              onPressed: onNotificationTap ?? () {},
              icon: Icon(
                Icons.notifications_outlined,
                size: 24.sp,
                color: colors.textPrimary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surfaceBorder, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 16,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 36.r,
                  backgroundColor: colors.surfaceDark,
                  child: Icon(
                    Icons.person_rounded,
                    size: 38.sp,
                    color: colors.textHint,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colors.textHint,
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

/// Kaydırmalı tema seçici: basınca geçilen temanın ikonuna doğru kayar.
class _ThemeToggleSwitch extends StatelessWidget {
  const _ThemeToggleSwitch({
    required this.isDark,
    required this.onToggle,
    required this.iconColor,
    required this.trackColor,
    required this.thumbColor,
  });

  final bool isDark;
  final VoidCallback onToggle;
  final Color iconColor;
  final Color trackColor;
  final Color thumbColor;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 280);
    const curve = Curves.easeInOut;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 72.w,
          height: 36.h,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppThemeColors.of(context).surfaceBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Kayyan dolgu: geçilen temanın tarafına gider (dark = sol, light = sağ)
              AnimatedAlign(
                duration: duration,
                curve: curve,
                alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
                child: AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  width: 32.w,
                  height: 28.h,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: thumbColor,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              // İkonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.dark_mode_rounded, size: 20.sp, color: iconColor),
                  Icon(Icons.light_mode_rounded, size: 20.sp, color: iconColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
