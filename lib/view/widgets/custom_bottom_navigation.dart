import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../services/auth_service.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  static const _logoutIndex = 2;
  int _currentIndex = 0;

  Future<void> _onTap(int index) async {
    if (index != _logoutIndex) {
      setState(() => _currentIndex = index);
      return;
    }

    // AuthGate detecta el cierre de sesión y muestra el login solo.
    final messenger = ScaffoldMessenger.of(context);
    try {
      await AuthService.signOut();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error al cerrar sesión: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.card,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: Colors.grey[400],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: 'Calendario'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Gráficas'),
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Cerrar sesión'),
      ],
    );
  }
}
