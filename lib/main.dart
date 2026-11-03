import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firesentinel/config/routes/app_routes.dart';
import 'package:firesentinel/domain/providers/providers.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔥 ¡ALERTA RECIBIDA EN SEGUNDO PLANO!: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SmokeAlertProvider())],
      child: const Design(), // Design debe contener a MainContent
    ),
  );
}

class Design extends StatefulWidget {
  const Design({super.key});

  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {
  @override
  void initState() {
    super.initState();
    _configurarNotificaciones(); // Inicia la configuración al abrir la app
  }

  // --- 5. CONFIGURACIÓN Y PERMISOS DE FIREBASE MESSAGING ---
  Future<void> _configurarNotificaciones() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Pedimos permisos al usuario (Obligatorio en Android 13+ y iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true, // ¡Clave para alertas de emergencia!
      provisional: false,
      sound: true, // Autoriza emitir sonidos
    );

    try {
      await messaging.subscribeToTopic('alertas_incendio');
      print('✅ ÉXITO: Suscrito al topic "alertas_incendio"');
    } catch (e) {
      print('❌ ERROR al suscribirse: $e');
    }

    print('Estado de permisos de notificación: ${settings.authorizationStatus}');

    // Escuchador para cuando la app está ABIERTA en la pantalla
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔥 ¡ALERTA EN PRIMER PLANO!: ${message.notification?.title}');

      // Opcional: Si quieres mostrar un aviso dentro de la app cuando está abierta
      if (message.notification != null) {
        // Aquí podrías disparar tu SmokeAlertProvider o mostrar un SnackBar
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(title: 'FireSentinel', debugShowCheckedModeBanner: false, routes: AppRoute.routes, initialRoute: AppRoute.homeRoute);
  }
}
