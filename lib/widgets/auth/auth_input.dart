import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthInput extends StatelessWidget {
  const AuthInput({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.enabled = true,
    this.maxLength,
    this.autofillHints,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDark.withValues(alpha: 1.0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.8), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        maxLength: maxLength,
        autofillHints: autofillHints,
        style: TextStyle(color: colors.textPrimary, fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: colors.textHint, fontSize: 16.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          counterText: maxLength != null ? '' : null,
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
