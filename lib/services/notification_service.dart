import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';

/// Configuración de Firebase Cloud Messaging.
///
/// Con la app cerrada o en segundo plano, Android/iOS muestran solos la
/// notificación que envía la Cloud Function. Con la app abierta FCM no la
/// muestra, por eso se presenta como SnackBar usando [messengerKey].
abstract final class NotificationService {
  /// Topic al que publica la Cloud Function `enviarAlertaIncendio`.
  static const fireAlertsTopic = 'alertas_incendio';

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static Future<void> init() async {
    final messaging = FirebaseMessaging.instance;

    // Obligatorio en Android 13+ e iOS. criticalAlert permite sonar en "No molestar" (iOS).
    await messaging.requestPermission(criticalAlert: true);

    try {
      await messaging.subscribeToTopic(fireAlertsTopic);
    } catch (e) {
      debugPrint('NotificationService: no se pudo suscribir a "$fireAlertsTopic": $e');
    }

    FirebaseMessaging.onMessage.listen(_showForegroundAlert);
  }

  static void _showForegroundAlert(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    messengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.accent,
        duration: const Duration(seconds: 8),
        content: Text(
          [notification.title, notification.body].whereType<String>().join('\n'),
          style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
