import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Botón principal que se deshabilita y muestra un spinner mientras carga
/// (evita envíos dobles del formulario).
class LoadingButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const LoadingButton({super.key, required this.label, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 3))
          : Text(label),
    );
  }
}
