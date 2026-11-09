import '../../config/constants/sensor_thresholds.dart';

/// Lectura del nodo `/sistema` que publica el ESP32 en Realtime Database.
class SensorData {
  final bool isAlertActive;
  final int gasLevel;
  final double temperature;
  final double humidity;

  const SensorData({this.isAlertActive = false, this.gasLevel = 0, this.temperature = 0, this.humidity = 0});

  static const empty = SensorData();

  /// Convierte el snapshot de Firebase. Tolera nodos faltantes o con tipo
  /// inesperado (p. ej. un int donde se espera double) sin lanzar excepciones.
  factory SensorData.fromMap(Map<Object?, Object?> map) => SensorData(
    isAlertActive: map['alerta'] == true,
    gasLevel: _num(map['nivel_gas']).toInt(),
    temperature: _num(map['temperatura']).toDouble(),
    humidity: _num(map['humedad']).toDouble(),
  );

  static num _num(Object? value) => value is num ? value : num.tryParse('$value') ?? 0;

  bool get isTemperatureHigh => temperature > SensorThresholds.temperature;
  bool get isGasHigh => gasLevel > SensorThresholds.gas;

  @override
  bool operator ==(Object other) =>
      other is SensorData &&
      other.isAlertActive == isAlertActive &&
      other.gasLevel == gasLevel &&
      other.temperature == temperature &&
      other.humidity == humidity;

  @override
  int get hashCode => Object.hash(isAlertActive, gasLevel, temperature, humidity);
}
