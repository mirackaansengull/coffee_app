import 'package:flutter/material.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.surfaceDark,
    required this.surfaceMedium,
    required this.surfaceBorder,
    required this.textPrimary,
    required this.textHint,
    required this.cursor,
    required this.overlayDark,
    required this.overlayDarkOpacity,
    required this.progressIndicator,
    required this.gradientBackground,
    required this.gradientSearchBar,
    required this.accent,
  });

  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color surfaceDark;
  final Color surfaceMedium;
  final Color surfaceBorder;
  final Color textPrimary;
  final Color textHint;
  final Color cursor;
  final Color overlayDark;
  final double overlayDarkOpacity;
  final Color progressIndicator;
  final LinearGradient gradientBackground;
  final LinearGradient gradientSearchBar;
  /// Turuncu vurgu rengi (login butonu, linkler)
  final Color accent;

  static AppThemeColors of(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeColors>();
    if (ext != null) return ext;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }

  static const AppThemeColors dark = AppThemeColors(
    backgroundPrimary: Color(0xFF1B1B1B),
    backgroundSecondary: Color(0xFF333333),
    surfaceDark: Color.fromARGB(255, 32, 32, 32),
    surfaceMedium: Color(0xFF3D3D3D),
    surfaceBorder: Color(0xFF505050),
    textPrimary: Color.fromARGB(255, 223, 223, 223),
    textHint: Color(0xFFBDBDBD),
    cursor: Colors.white,
    overlayDark: Colors.black,
    overlayDarkOpacity: 0.75,
    progressIndicator: Colors.white,
    gradientBackground: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1B1B1B), Color(0xFF333333)],
    ),
    gradientSearchBar: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF272727), Color(0xFF3D3D3D)],
    ),
    accent: Color(0xFFE65100),
  );

  static const AppThemeColors light = AppThemeColors(
    backgroundPrimary: Color(0xFFF5F5F5),
    backgroundSecondary: Color(0xFFFFFFFF),
    surfaceDark: Color(0xFFEEEEEE),
    surfaceMedium: Color(0xFFE0E0E0),
    surfaceBorder: Color(0xFFBDBDBD),
    textPrimary: Color(0xFF212121),
    textHint: Color(0xFF757575),
    cursor: Color(0xFF212121),
    overlayDark: Colors.black,
    overlayDarkOpacity: 0.4,
    progressIndicator: Color(0xFF6D4C41),
    gradientBackground: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF5F5F5), Color(0xFFFFFFFF)],
    ),
    gradientSearchBar: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFEEEEEE), Color(0xFFE0E0E0)],
    ),
    accent: Color(0xFFE65100),
  );

  @override
  ThemeExtension<AppThemeColors> copyWith({
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? surfaceDark,
    Color? surfaceMedium,
    Color? surfaceBorder,
    Color? textPrimary,
    Color? textHint,
    Color? cursor,
    Color? overlayDark,
    double? overlayDarkOpacity,
    Color? progressIndicator,
    LinearGradient? gradientBackground,
    LinearGradient? gradientSearchBar,
    Color? accent,
  }) {
    return AppThemeColors(
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      surfaceMedium: surfaceMedium ?? this.surfaceMedium,
      surfaceBorder: surfaceBorder ?? this.surfaceBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textHint: textHint ?? this.textHint,
      cursor: cursor ?? this.cursor,
      overlayDark: overlayDark ?? this.overlayDark,
      overlayDarkOpacity: overlayDarkOpacity ?? this.overlayDarkOpacity,
      progressIndicator: progressIndicator ?? this.progressIndicator,
      gradientBackground: gradientBackground ?? this.gradientBackground,
      gradientSearchBar: gradientSearchBar ?? this.gradientSearchBar,
      accent: accent ?? this.accent,
    );
  }

  @override
  ThemeExtension<AppThemeColors> lerp(
    ThemeExtension<AppThemeColors>? other,
    double t,
  ) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      backgroundPrimary: Color.lerp(
        backgroundPrimary,
        other.backgroundPrimary,
        t,
      )!,
      backgroundSecondary: Color.lerp(
        backgroundSecondary,
        other.backgroundSecondary,
        t,
      )!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      surfaceMedium: Color.lerp(surfaceMedium, other.surfaceMedium, t)!,
      surfaceBorder: Color.lerp(surfaceBorder, other.surfaceBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      cursor: Color.lerp(cursor, other.cursor, t)!,
      overlayDark: Color.lerp(overlayDark, other.overlayDark, t)!,
      overlayDarkOpacity:
          overlayDarkOpacity +
          (other.overlayDarkOpacity - overlayDarkOpacity) * t,
      progressIndicator: Color.lerp(
        progressIndicator,
        other.progressIndicator,
        t,
      )!,
      gradientBackground: t < 0.5
          ? gradientBackground
          : other.gradientBackground,
      gradientSearchBar: t < 0.5 ? gradientSearchBar : other.gradientSearchBar,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}
