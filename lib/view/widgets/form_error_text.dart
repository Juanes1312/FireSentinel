import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Mensaje de error de formulario. No ocupa espacio si [message] es null.
class FormErrorText extends StatelessWidget {
  final String? message;

  const FormErrorText(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    if (message == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.warning, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
