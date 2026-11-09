import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../services/auth_service.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final displayName = AuthService.currentUser?.displayName?.trim() ?? '';
    final firstName = displayName.isEmpty ? 'Usuario' : displayName.split(' ').first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.menu, color: AppColors.white), onPressed: () {}),
        Column(
          children: [
            Hero(tag: 'logo', child: Image.asset('assets/logo.png', height: 45)),
            const SizedBox(height: 5),
            Text('Hola, $firstName', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ],
        ),
        IconButton(icon: const Icon(Icons.notifications_none, color: AppColors.white), onPressed: () {}),
      ],
    );
  }
}
