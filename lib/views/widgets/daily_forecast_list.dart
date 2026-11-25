import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/weather_model.dart';
import '../../theme/app_theme.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecastItem> items;

  const DailyForecastList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: AppTheme.primaryPink, size: 20),
              SizedBox(width: 8),
              Text(
                'Perkiraan Beberapa Hari ke Depan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length > 7 ? 7 : items.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.softPink.withValues(alpha: 0.3),
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final day = items[index];
              final dateStr = DateFormat('EEEE, d MMM', 'id_ID').format(day.date);
              final isToday = index == 0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        isToday ? 'Hari Ini' : dateStr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                          color: isToday ? AppTheme.primaryPink : AppTheme.textDark,
                        ),
                      ),
                    ),
                    Text(
                      day.weatherIcon,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(width: 8),
                    if (day.precipitationProbability > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.softBlue.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.water_drop, size: 10, color: AppTheme.primaryBlue),
                            const SizedBox(width: 2),
                            Text(
                              '${day.precipitationProbability}%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.deepBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '${day.maxTemp.round()}°',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${day.minTemp.round()}°',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppTheme.textMuted.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
