import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/providers/sensor_provider.dart';
import '../../services/auth_service.dart';
import 'home_page.dart';
import 'login_page.dart';

/// Muestra el dashboard si hay un usuario con el correo verificado y el
/// login en cualquier otro caso. Reacciona solo al iniciar/cerrar sesión,
/// así que las pantallas no tienen que navegar manualmente.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges(),
      initialData: AuthService.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null || !user.emailVerified) return const LoginPage();

        // El provider vive solo mientras hay sesión: se crea al entrar y
        // cancela su listener de Firebase al cerrar sesión.
        return ChangeNotifierProvider(create: (_) => SensorProvider(), child: const HomePage());
      },
    );
  }
}
