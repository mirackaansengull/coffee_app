import 'package:flutter/material.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/core/constants/app_constants.dart';

/// MaterialApp theme ve darkTheme verisi.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final c = AppThemeColors.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppConstants.fontFamily,
      scaffoldBackgroundColor: c.backgroundSecondary,
      colorScheme: ColorScheme.dark(
        primary: c.textPrimary,
        surface: c.backgroundPrimary,
        onSurface: c.textPrimary,
        onSurfaceVariant: c.textHint,
      ),
      extensions: const [AppThemeColors.dark],
      textTheme: TextTheme(
        bodyLarge: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        bodyMedium: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        bodySmall: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        titleLarge: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        labelLarge: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        labelSmall: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        displayLarge: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        displayMedium: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        displaySmall: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.backgroundPrimary,
        foregroundColor: c.textPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: c.textHint,
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.progressIndicator,
      ),
    );
  }

  static ThemeData get light {
    final c = AppThemeColors.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppConstants.fontFamily,
      scaffoldBackgroundColor: c.backgroundSecondary,
      colorScheme: ColorScheme.light(
        primary: c.textPrimary,
        surface: c.backgroundPrimary,
        onSurface: c.textPrimary,
        onSurfaceVariant: c.textHint,
      ),
      extensions: const [AppThemeColors.light],
      textTheme: TextTheme(
        bodyLarge: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        bodyMedium: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        bodySmall: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        titleLarge: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        labelLarge: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        labelSmall: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        displayLarge: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        displayMedium: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        displaySmall: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.backgroundPrimary,
        foregroundColor: c.textPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: c.textHint,
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
        ),
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.progressIndicator,
      ),
    );
  }
}
