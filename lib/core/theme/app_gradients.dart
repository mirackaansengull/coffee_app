import 'package:flutter/material.dart';
import 'package:coffee_app/core/theme/app_colors.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.backgroundPrimary, AppColors.backgroundSecondary],
  );

  static const LinearGradient searchBar = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.surfaceDark, AppColors.surfaceMedium],
  );
}
