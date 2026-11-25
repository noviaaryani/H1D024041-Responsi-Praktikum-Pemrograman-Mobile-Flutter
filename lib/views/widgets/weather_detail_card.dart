import 'package:flutter/material.dart';
import '../../models/weather_model.dart';
import '../../theme/app_theme.dart';

class WeatherDetailCard extends StatelessWidget {
  final WeatherData current;
  final DailyForecastItem? todayDaily;

  const WeatherDetailCard({
    super.key,
    required this.current,
    this.todayDaily,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPink.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildMetricItem(
                icon: Icons.water_drop_outlined,
                iconColor: AppTheme.primaryBlue,
                label: 'Kelembapan',
                value: '${current.relativeHumidity}%',
              ),
              _buildDivider(),
              _buildMetricItem(
                icon: Icons.air_rounded,
                iconColor: AppTheme.primaryPink,
                label: 'Kecepatan Angin',
                value: '${current.windSpeed} km/h',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppTheme.softPink.withValues(alpha: 0.4), height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMetricItem(
                icon: Icons.umbrella_outlined,
                iconColor: AppTheme.primaryBlue,
                label: 'Curah Hujan',
                value: '${current.precipitation} mm',
              ),
              _buildDivider(),
              _buildMetricItem(
                icon: Icons.waves_rounded,
                iconColor: AppTheme.primaryPink,
                label: 'Peluang Hujan',
                value: '${todayDaily?.precipitationProbability ?? 0}%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppTheme.softPink.withValues(alpha: 0.3),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
