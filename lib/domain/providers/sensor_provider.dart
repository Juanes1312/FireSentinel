import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../models/sensor_data.dart';

/// Escucha en tiempo real el nodo `/sistema` y expone la última lectura.
///
/// Usa un único listener sobre el nodo padre (antes eran cuatro, uno por
/// campo), así el ESP32 actualiza varios valores y la UI se reconstruye una
/// sola vez. Se crea al entrar al dashboard y se libera al cerrar sesión.
class SensorProvider extends ChangeNotifier {
  late final StreamSubscription<DatabaseEvent> _subscription;
  SensorData _data = SensorData.empty;

  SensorProvider({DatabaseReference? ref}) {
    _subscription = (ref ?? FirebaseDatabase.instance.ref('sistema')).onValue.listen(
      _onEvent,
      onError: (Object e) => debugPrint('SensorProvider: error leyendo /sistema: $e'),
    );
  }

  SensorData get data => _data;

  void _onEvent(DatabaseEvent event) {
    final value = event.snapshot.value;
    final next = value is Map ? SensorData.fromMap(value) : SensorData.empty;
    if (next == _data) return;
    _data = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
