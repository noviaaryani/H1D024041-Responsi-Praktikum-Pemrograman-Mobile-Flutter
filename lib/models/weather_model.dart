class WeatherData {
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  WeatherData({
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      apparentTemperature: (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get weatherDescription {
    switch (weatherCode) {
      case 0:
        return 'Cerah Berawan';
      case 1:
      case 2:
      case 3:
        return 'Sebagian Berawan';
      case 45:
      case 48:
        return 'Berkabut';
      case 51:
      case 53:
      case 55:
        return 'Gerimis Ringan';
      case 61:
      case 63:
      case 65:
        return 'Hujan Sedang';
      case 71:
      case 73:
      case 75:
        return 'Salju';
      case 80:
      case 81:
      case 82:
        return 'Hujan Lebat';
      case 95:
      case 96:
      case 99:
        return 'Badai Petir';
      default:
        return 'Cerah';
    }
  }

  String get weatherIcon {
    switch (weatherCode) {
      case 0:
        return '☀️';
      case 1:
      case 2:
      case 3:
        return '⛅';
      case 45:
      case 48:
        return '🌫️';
      case 51:
      case 53:
      case 55:
        return '🌦️';
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return '🌧️';
      case 71:
      case 73:
      case 75:
        return '❄️';
      case 95:
      case 96:
      case 99:
        return '⛈️';
      default:
        return '🌤️';
    }
  }
}

class DailyForecastItem {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int precipitationProbability;
  final int weatherCode;

  DailyForecastItem({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitationProbability,
    required this.weatherCode,
  });

  String get weatherIcon {
    switch (weatherCode) {
      case 0:
        return '☀️';
      case 1:
      case 2:
      case 3:
        return '⛅';
      case 45:
      case 48:
        return '🌫️';
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return '🌧️';
      case 95:
      case 96:
      case 99:
        return '⛈️';
      default:
        return '🌤️';
    }
  }
}

class WeatherModel {
  final WeatherData current;
  final List<DailyForecastItem> daily;

  WeatherModel({
    required this.current,
    required this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentData = WeatherData.fromJson(json['current'] ?? {});

    final dailyJson = json['daily'] as Map<String, dynamic>? ?? {};
    final times = dailyJson['time'] as List<dynamic>? ?? [];
    final maxTemps = dailyJson['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = dailyJson['temperature_2m_min'] as List<dynamic>? ?? [];
    final rainProbs = dailyJson['precipitation_probability_max'] as List<dynamic>? ?? [];
    final codes = dailyJson['weather_code'] as List<dynamic>? ?? [];

    List<DailyForecastItem> dailyList = [];
    for (int i = 0; i < times.length; i++) {
      dailyList.add(
        DailyForecastItem(
          date: DateTime.tryParse(times[i].toString()) ?? DateTime.now().add(Duration(days: i)),
          maxTemp: (i < maxTemps.length ? (maxTemps[i] as num).toDouble() : 0.0),
          minTemp: (i < minTemps.length ? (minTemps[i] as num).toDouble() : 0.0),
          precipitationProbability: (i < rainProbs.length ? (rainProbs[i] as num?)?.toInt() ?? 0 : 0),
          weatherCode: (i < codes.length ? (codes[i] as num?)?.toInt() ?? 0 : 0),
        ),
      );
    }

    return WeatherModel(
      current: currentData,
      daily: dailyList,
    );
  }
}
