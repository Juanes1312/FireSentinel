import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/providers/sensor_provider.dart';
import '../widgets/widgets.dart';

/// Dashboard con el estado de los sensores en tiempo real.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FireBackground(
        gradientEnd: 0.4,
        child: SafeArea(
          // SliverFillRemaining permite que el Spacer empuje las métricas
          // abajo y aun así hacer scroll en pantallas pequeñas (sustituye
          // a LayoutBuilder + IntrinsicHeight, que es más costoso).
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: _Dashboard()),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context) {
    // Solo este widget se reconstruye cuando llegan datos nuevos del ESP32.
    final data = context.watch<SensorProvider>().data;

    return Column(
      children: [
        const SizedBox(height: 10),
        const HomeHeader(),
        const SizedBox(height: 20),
        StatusCircle(isDanger: data.isAlertActive),
        const Spacer(),
        const SizedBox(height: 20),
        MetricsRow(data: data),
        const SizedBox(height: 20),
        ActionButtonsRow(isDanger: data.isAlertActive),
        const SizedBox(height: 20),
      ],
    );
  }
}
