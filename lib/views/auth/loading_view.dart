import 'package:coffee_app/core/constants/asset_paths.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key, this.onInit});

  /// Backend uyandıktan sonra auth check tetiklenir (main'de atanır).
  final Future<void> Function()? onInit;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final logoColor = isLight ? Colors.black : Colors.white;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AssetPaths.background,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: BoxDecoration(gradient: colors.gradientBackground),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.backgroundPrimary.withValues(alpha: 0.8),
                  colors.backgroundSecondary.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
                    child: Image.asset(
                      AssetPaths.logoHorizontal,
                      width: 160.w,
                      height: 64.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: 32.w,
                    height: 32.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.progressIndicator,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
