import 'package:flutter/material.dart';

/// Paleta de colores de FireSentinel.
abstract final class AppColors {
  /// Fondo principal (azul marino oscuro).
  static const background = Color(0xFF0B172A);

  /// Fondo de tarjetas y barra de navegación (azul medianoche más claro).
  static const card = Color(0xFF16253B);

  /// Naranja/rojo fuego de la parte superior de los degradados.
  static const fire = Color(0xFFD84315);

  /// Rojo del escudo de FireSentinel (acentos, ítem seleccionado).
  static const accent = Color(0xFFD32F2F);

  /// Rojo fuerte de los botones principales.
  static const button = Color(0xFFD30000);

  /// Estado "SEGURO".
  static const safe = Color(0xFF00C853);

  /// Estado "PELIGRO".
  static const danger = Colors.redAccent;

  /// Tarjetas de métricas en rango normal.
  static const metricNormal = Color(0xFF0277BD);

  /// Tarjetas de métricas fuera de rango.
  static const metricAlert = Colors.red;

  /// Mensajes de error / advertencia sobre fondo oscuro.
  static const warning = Colors.amber;

  static const white = Colors.white;
  static const textSecondary = Colors.white70;
}
