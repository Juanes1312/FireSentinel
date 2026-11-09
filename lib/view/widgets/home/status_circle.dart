import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';

/// Círculo central que indica si el sistema está en estado SEGURO o PELIGRO.
class StatusCircle extends StatelessWidget {
  final bool isDanger;

  const StatusCircle({super.key, required this.isDanger});

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? AppColors.danger : AppColors.safe;

    return Container(
      width: 220,
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.card,
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 40, spreadRadius: 5)],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: AppColors.white.withValues(alpha: 0.2), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ESTADO:', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            Text(
              isDanger ? 'PELIGRO' : 'SEGURO',
              style: const TextStyle(color: AppColors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
