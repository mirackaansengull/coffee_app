import 'package:coffee_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/loading_background.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: AppColors.overlayDark.withValues(
              alpha: AppColors.overlayDarkOpacity,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 300.w,
                  height: 300.h,
                ),
                SizedBox(
                  width: 40.w,
                  height: 50.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 4.w,
                    color: AppColors.progressIndicator,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
