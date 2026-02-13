import 'package:flutter/material.dart';
import 'package:coffee_app/core/theme/app_colors.dart';
import 'package:coffee_app/core/constants/app_constants.dart';

/// MaterialApp theme ve darkTheme verisi.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppConstants.fontFamily,
      scaffoldBackgroundColor: AppColors.backgroundSecondary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.textPrimary,
        surface: AppColors.backgroundPrimary,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textHint,
      ),
      textTheme: TextTheme(
        bodyLarge: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w300),
        bodyMedium: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w300),
        bodySmall: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w300),
        titleLarge: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w500),
        titleMedium: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w500),
        titleSmall: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w500),
        labelLarge: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w500),
        labelMedium: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w300),
        labelSmall: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w300),
        displayLarge: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w500),
        displayMedium: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w500),
        displaySmall: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w500),
        headlineLarge: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w500),
        headlineMedium: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w500),
        headlineSmall: const TextStyle(fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w500),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: AppColors.textHint,
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.progressIndicator,
      ),
    );
  }
}
