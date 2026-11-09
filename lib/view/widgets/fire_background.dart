import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Fondo de la marca: degradado fuego → azul marino con el logo como marca
/// de agua. Antes estaba copiado en login, registro y dashboard.
class FireBackground extends StatelessWidget {
  /// Punto (0–1) donde el degradado termina de pasar a azul marino.
  final double gradientEnd;
  final Widget child;

  const FireBackground({super.key, this.gradientEnd = 0.6, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [AppColors.fire, AppColors.background],
          stops: [0, gradientEnd],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // `opacity` en Image.asset evita el saveLayer que genera el widget Opacity.
          Transform.scale(
            scale: 1.5,
            child: Image.asset('assets/logo.png', fit: BoxFit.contain, opacity: const AlwaysStoppedAnimation(0.03)),
          ),
          child,
        ],
      ),
    );
  }
}
