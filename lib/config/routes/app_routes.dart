import 'package:flutter/material.dart';
import '../../view/screens/screens.dart';

class AppRoute {
  static const String loginRoute = '/';
  static const String homeRoute = '/home';

  static Map<String, Widget Function(BuildContext)> routes = {
    loginRoute: (context) => const LoginPage(),
    homeRoute: (context) => const CompositeDesign()
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case homeRoute:
        return MaterialPageRoute(builder: (context) => const CompositeDesign());
      default:
        return MaterialPageRoute(builder: (context) => const Text('Error: Ruta desconocida'));
    }
  }
}
