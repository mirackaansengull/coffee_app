import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan tüm renkler.
/// Yeni renk eklerken bu sınıfı kullan.
class AppColors {
  AppColors._();

  // Ana arka plan renkleri
  static const Color backgroundPrimary = Color(0xFF1B1B1B); // 27, 27, 27
  static const Color backgroundSecondary = Color(0xFF333333); // 51, 51, 51
  static const Color surfaceDark = Color(0xFF272727);
  static const Color surfaceMedium = Color(0xFF3D3D3D);

  // Metin ve ikon
  static const Color textPrimary = Color.fromARGB(255, 223, 223, 223);
  static const Color textHint = Color(0xFFBDBDBD); // grey.shade400 benzeri
  static const Color cursor = Colors.white;

  // Overlay / efekt
  static const Color overlayDark = Colors.black;
  static double get overlayDarkOpacity => 0.75;

  // Progress / vurgu
  static const Color progressIndicator = Colors.white;
}

/// Uygulama genelinde kullanılan gradient tanımları.
class AppGradients {
  AppGradients._();

  /// Ana sayfa arka plan gradient'i (yukarıdan aşağı)
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.backgroundPrimary, AppColors.backgroundSecondary],
  );

  /// Arama kutusu gradient'i (soldan sağa)
  static const LinearGradient searchBar = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.surfaceDark, AppColors.surfaceMedium],
  );
}

/// Border radius değerleri (theme ile kullanmak için sabit, .r ile kullanılanlar widget'ta).
class AppRadius {
  AppRadius._();

  static const double small = 10.0;
  static const double medium = 12.0;
  static const double large = 16.0;
}

/// Uygulama tema verisi.
/// MaterialApp'te theme ve darkTheme olarak kullan.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.backgroundSecondary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.textPrimary,
        surface: AppColors.backgroundPrimary,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textHint,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
        ),
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: AppColors.textHint,
          fontFamily: 'Poppins',
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
