import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersSectionHeader extends StatelessWidget {
  const OrdersSectionHeader({
    super.key,
    required this.onSeeAllTap,
  });

  final VoidCallback onSeeAllTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Text(
            'Siparişlerim',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onSeeAllTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tüm siparişler',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w300,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_right_rounded,
                size: 18.sp,
                color: colors.textPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
