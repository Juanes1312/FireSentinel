import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tema global. Centraliza los estilos de inputs y botones que antes
/// se repetían en cada pantalla.
abstract final class AppTheme {
  static final _radius = BorderRadius.circular(10);

  static OutlineInputBorder _border(Color color, double width) =>
      OutlineInputBorder(borderRadius: _radius, borderSide: BorderSide(color: color, width: width));

  static ThemeData get dark => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent, brightness: Brightness.dark),
    scaffoldBackgroundColor: AppColors.background,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white.withValues(alpha: 0.05),
      labelStyle: const TextStyle(color: AppColors.white),
      prefixIconColor: AppColors.textSecondary,
      errorStyle: const TextStyle(color: AppColors.warning),
      enabledBorder: _border(AppColors.textSecondary, 1.5),
      focusedBorder: _border(AppColors.white, 2),
      errorBorder: _border(AppColors.warning, 1.5),
      focusedErrorBorder: _border(AppColors.warning, 2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.button.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: _radius),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.white, textStyle: const TextStyle(fontSize: 16)),
    ),
  );
}
