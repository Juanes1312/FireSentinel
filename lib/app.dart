import 'package:flutter/material.dart';

import 'config/routes/app_routes.dart';
import 'config/theme/app_theme.dart';
import 'services/notification_service.dart';

class FireSentinelApp extends StatelessWidget {
  const FireSentinelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireSentinel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      scaffoldMessengerKey: NotificationService.messengerKey,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.root,
    );
  }
}
