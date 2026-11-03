import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class SmokeAlertProvider extends ChangeNotifier {
  // 1. Variables privadas
  bool _isAlertActive = false;
  int _gasLevel = 0;
  double _temperatura = 0.0;
  double _humedad = 0.0;

  // 2. Getters públicos
  bool get isAlertActive => _isAlertActive;
  int get gasLevel => _gasLevel;
  double get temperatura => _temperatura;
  double get humedad => _humedad;

  SmokeAlertProvider() {
    _setupListeners();
  }

  void _setupListeners() {
    final dbRef = FirebaseDatabase.instance.ref('sistema');

    // Listener para Alerta
    dbRef.child('alerta').onValue.listen((event) {
      _isAlertActive = event.snapshot.value as bool? ?? false;
      notifyListeners();
    });

    // Listener para Nivel de Gas
    dbRef.child('nivel_gas').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        _gasLevel = (value as num).toInt();
        notifyListeners();
      }
    });

    // Listener para Temperatura
    dbRef.child('temperatura').onValue.listen((event) {
      _temperatura = (event.snapshot.value as num?)?.toDouble() ?? 0.0;
      notifyListeners();
    });

    // Listener para Humedad
    dbRef.child('humedad').onValue.listen((event) {
      _humedad = (event.snapshot.value as num?)?.toDouble() ?? 0.0;
      notifyListeners();
    });
  }
}