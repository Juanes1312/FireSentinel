import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';

/// Accesos rápidos del dashboard. Las acciones aún no están implementadas.
class ActionButtonsRow extends StatelessWidget {
  final bool isDanger;

  const ActionButtonsRow({super.key, required this.isDanger});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        _ActionButton(text: 'Alertas', filledColor: isDanger ? Colors.yellow : AppColors.white, onTap: () {}),
        _ActionButton(text: 'Historial', onTap: () {}),
        _ActionButton(text: 'Ajustes', onTap: () {}),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;

  /// Si es null el botón se dibuja solo con borde.
  final Color? filledColor;
  final VoidCallback onTap;

  const _ActionButton({required this.text, this.filledColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isFilled = filledColor != null;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: filledColor,
            borderRadius: BorderRadius.circular(8),
            border: isFilled ? null : Border.all(color: Colors.white54, width: 1.5),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: isFilled ? Colors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
