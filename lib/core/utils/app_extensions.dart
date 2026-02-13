import 'package:flutter/material.dart';

/// Genel extension'lar (ileride date, string format vb. eklenebilir).
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}
