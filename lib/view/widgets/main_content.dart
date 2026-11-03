import 'package:firesentinel/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firesentinel/domain/providers/smoke_alert_provider.dart';
import 'package:provider/provider.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmokeAlertProvider>(
      builder: (context, smokeProvider, child) {
        // Obtenemos los valores reactivos del provider
        final bool esPeligro = smokeProvider.isAlertActive;
        final int nivelGas = smokeProvider.gasLevel;
        final double temperatura = smokeProvider.temperatura;
        final double humedad = smokeProvider.humedad;

        return Stack(
          children: [
            // 1. EL FONDO DEGRADADO
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFD84315),
                    Color(0xFF0B172A),
                  ],
                  stops: [0.0, 0.4],
                ),
              ),
            ),

            // 2. LA MARCA DE AGUA
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: Transform.scale(
                  scale: 1.5,
                  child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                ),
              ),
            ),

            // 3. EL CONTENIDO PRINCIPAL
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const _TopHeader(),
                              const SizedBox(height: 20),
                              
                              // Indicador de estado dinámico
                              _StatusCircle(
                                estado: esPeligro ? 'PELIGRO' : 'SEGURO', 
                                color: esPeligro ? Colors.redAccent : const Color(0xFF00C853)
                              ),

                              const Spacer(),
                              const SizedBox(height: 20),
                              
                              // Métricas dinámicas
                              _MetricsRow(
                                valorGas: nivelGas, 
                                temp: temperatura, 
                                hum: humedad
                              ),

                              const SizedBox(height: 20),

                              // Botones de acción dinámicos
                              _ActionButtonsRow(esPeligro: esPeligro),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// --- COMPONENTE: ENCABEZADO SUPERIOR ---
class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final nombreUsuario = user?.displayName?.split(' ')[0] ?? 'Usuario';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () {}),
        Column(
          children: [
            Hero(tag: 'logo', child: Image.asset('assets/logo.png', height: 45)),
            const SizedBox(height: 5),
            Text('Hola, $nombreUsuario', style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
        IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
      ],
    );
  }
}

// --- COMPONENTE: CÍRCULO CENTRAL DE ESTADO ---
class _StatusCircle extends StatelessWidget {
  final String estado;
  final Color color;

  const _StatusCircle({required this.estado, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kCardBackgroundColor,
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 40, spreadRadius: 5)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('ESTADO:', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              Text(estado, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}

// --- COMPONENTE: FILA DE MÉTRICAS ---
class _MetricsRow extends StatelessWidget {
  final int valorGas;
  final double temp;
  final double hum;

  const _MetricsRow({required this.valorGas, required this.temp, required this.hum});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _MetricCard(
          title: 'Temperatura', 
          value: '${temp.toStringAsFixed(1)}°C', 
          icon: Icons.thermostat, 
          color: temp > 31.0 ? Colors.red : const Color(0xFF0277BD)
        ),
        _MetricCard(
          title: 'Gas', 
          value: '$valorGas ppm', 
          icon: Icons.local_fire_department, 
          color: valorGas > 1500 ? Colors.red : const Color(0xFF0277BD)
        ),
        _MetricCard(
          title: 'Humedad', 
          value: '${hum.toStringAsFixed(0)}%', 
          icon: Icons.water_drop, 
          color: const Color(0xFF0277BD)
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// --- COMPONENTE: BOTONES DE ACCIÓN ---
class _ActionButtonsRow extends StatelessWidget {
  final bool esPeligro;
  const _ActionButtonsRow({required this.esPeligro});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            text: 'Alertas',
            isFilled: true,
            colorOverride: esPeligro ? Colors.yellow : Colors.white,
            onTap: () => print("Abriendo alertas..."),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            text: 'Historial',
            isFilled: false,
            onTap: () => print("Abriendo historial..."),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            text: 'Ajustes',
            isFilled: false,
            onTap: () => print("Abriendo ajustes..."),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final bool isFilled;
  final Color? colorOverride;
  final VoidCallback onTap;

  const _ActionButton({required this.text, required this.isFilled, this.colorOverride, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isFilled ? (colorOverride ?? Colors.white) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isFilled ? null : Border.all(color: Colors.white54, width: 1.5),
        ),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: isFilled ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}