/// Umbrales a partir de los cuales una métrica se pinta en rojo en el dashboard.
///
/// La alerta real (`/sistema/alerta`) la decide el ESP32; estos valores
/// solo afectan la visualización. Mantenlos alineados con el firmware.
abstract final class SensorThresholds {
  /// Temperatura en °C (DHT11).
  static const double temperature = 31.0;

  /// Lectura del MQ-2 tal como la publica el ESP32.
  static const int gas = 1500;
}
