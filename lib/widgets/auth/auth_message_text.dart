import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthMessageText extends StatelessWidget {
  const AuthMessageText({super.key, required this.text, this.isError = false});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Text(
      text,
      style: TextStyle(
        color: isError ? Colors.red.shade300 : colors.progressIndicator,
        fontSize: 13.sp,
      ),
    );
  }
}
