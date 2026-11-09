import 'package:firesentinel/config/constants/sensor_thresholds.dart';
import 'package:firesentinel/domain/models/sensor_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SensorData.fromMap', () {
    test('lee un snapshot completo del ESP32', () {
      final data = SensorData.fromMap({'alerta': true, 'nivel_gas': 1820, 'temperatura': 29.5, 'humedad': 61});

      expect(data.isAlertActive, isTrue);
      expect(data.gasLevel, 1820);
      expect(data.temperature, 29.5);
      expect(data.humidity, 61.0);
    });

    test('usa valores por defecto si faltan nodos', () {
      expect(SensorData.fromMap({}), SensorData.empty);
    });

    test('tolera tipos inesperados sin lanzar excepciones', () {
      final data = SensorData.fromMap({'alerta': 'true', 'nivel_gas': 120.7, 'temperatura': '25.3', 'humedad': null});

      expect(data.isAlertActive, isFalse);
      expect(data.gasLevel, 120);
      expect(data.temperature, 25.3);
      expect(data.humidity, 0);
    });
  });

  group('umbrales', () {
    test('marcan temperatura y gas por encima del límite', () {
      const high = SensorData(temperature: SensorThresholds.temperature + 1, gasLevel: SensorThresholds.gas + 1);
      const limit = SensorData(temperature: SensorThresholds.temperature, gasLevel: SensorThresholds.gas);

      expect(high.isTemperatureHigh, isTrue);
      expect(high.isGasHigh, isTrue);
      expect(limit.isTemperatureHigh, isFalse);
      expect(limit.isGasHigh, isFalse);
    });
  });
}
