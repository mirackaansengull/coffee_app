import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan tüm renkler.
class AppColors {
  AppColors._();

  static const Color backgroundPrimary = Color(0xFF1B1B1B);
  static const Color backgroundSecondary = Color(0xFF333333);
  static const Color surfaceDark = Color(0xFF272727);
  static const Color surfaceMedium = Color(0xFF3D3D3D);

  static const Color textPrimary = Color.fromARGB(255, 223, 223, 223);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color cursor = Colors.white;

  static const Color overlayDark = Colors.black;
  static double get overlayDarkOpacity => 0.75;

  static const Color progressIndicator = Colors.white;
}
