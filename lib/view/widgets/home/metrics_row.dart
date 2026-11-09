import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../domain/models/sensor_data.dart';

/// Tarjetas de temperatura, gas y humedad.
class MetricsRow extends StatelessWidget {
  final SensorData data;

  const MetricsRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetricCard(
          title: 'Temperatura',
          value: '${data.temperature.toStringAsFixed(1)}°C',
          icon: Icons.thermostat,
          isAlert: data.isTemperatureHigh,
        ),
        _MetricCard(
          title: 'Gas',
          value: '${data.gasLevel} ppm',
          icon: Icons.local_fire_department,
          isAlert: data.isGasHigh,
        ),
        _MetricCard(
          title: 'Humedad',
          value: '${data.humidity.toStringAsFixed(0)}%',
          icon: Icons.water_drop,
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isAlert;

  const _MetricCard({required this.title, required this.value, required this.icon, this.isAlert = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: isAlert ? AppColors.metricAlert : AppColors.metricNormal,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 5, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.white, size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
