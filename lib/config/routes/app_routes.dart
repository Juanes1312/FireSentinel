import 'package:flutter/material.dart';

import '../../view/screens/screens.dart';

abstract final class AppRoutes {
  /// Raíz: decide entre login y dashboard según la sesión.
  static const root = '/';
  static const register = '/register';

  static final Map<String, WidgetBuilder> routes = {
    root: (_) => const AuthGate(),
    register: (_) => const RegisterPage(),
  };
}
